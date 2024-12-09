#!/bin/bash

#add an alias name in your .bashrc and this will do the rest. Same thing, just another layer. 


set -a
# Get the directory where the alias is called
DIR="$(pwd)"

# Run everything from the directory
cd "$DIR"
echo "Running from: $DIR"
ls

            cat <<'WHOOPI' > WHOOPI.sh
#!/bin/bash


# Install xclip if not installed
if ! command -v xclip &>/dev/null; then
    echo "xclip not found. Installing..."
    sudo apt-get update && sudo apt-get install -y xclip
fi

# Step 1: Launch xed for user to input content
xed tempfile.txt

# Wait for xed to close
echo "xed closed. Reading contents of tempfile.txt."

# Step 2: Read the contents of tempfile.txt
content=$(<tempfile.txt)

# Step 3: Use the content as layer2_logic
# Ensure special characters are properly escaped
escaped_content=$(printf '%s\n' "$content" | sed 's/[\/&]/\\&/g')
    # Determine the file extension based on content
if [[ $content == import* ]]; then
    layer2_filename="layer2.py"
else
    layer2_filename="layer2.sh"
fi
# Determine the top_encoding content
if [[ $content == import*  ]]; then
    top_encoding=""
else
    top_encoding="#!/bin/bash"
fi
# Determine the command to execute based on top_encoding
if [[ $content == import* ]]; then
    run_command="python3 " 
else
    run_command="./"
fi

# Function to create and execute a layer
create_layer() {
    local layer_name="$1"       # Name of the current layer
    local layer_content="$2"    # Content for the layer
    local heredoc_delim="$3"    # Heredoc delimiter for the current layer

#    echo "Creating ${layer_name}.sh..."

    # Create the temporary script
    cat <<EOF > "${layer_name}.sh"
#!/bin/bash
# Temporary script: ${layer_name}
echo "Executing ${layer_name}.sh"
${layer_content}

EOF

    # Make the script executable
    chmod +x "${layer_name}.sh"

    # Execute the script
    ./"${layer_name}.sh"

    # Clean up the script
    rm -f "${layer_name}.sh"
    echo "Cleaned up ${layer_name}.sh"
}

# Step 4: Prepare Layer 2 content with user's input
layer2_content=$(cat <<EOL
            cat <<'INNERDOX' > $layer2_filename
$top_encoding

${content}
INNERDOX
            chmod +x $layer2_filename
            $run_command$layer2_filename
            rm -f $layer2_filename
EOL
)

# Step 5: Create Layer 1 with Layer 2 content
layer1_content="#!/bin/bash

${layer2_content}

"

# Copy the combined Layer 1 script to the clipboard
echo "$layer1_content" | xclip -selection clipboard

echo "Combined script copied to clipboard."

# Clean up
rm -f tempfile.txt

# Optionally, you can output the combined script to verify
# echo "$layer1_content"
WHOOPI
            chmod +x WHOOPI.sh
            ./WHOOPI.sh
            rm -f WHOOPI.sh


