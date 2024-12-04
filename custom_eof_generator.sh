#!/bin/bash

# .____                                        /\                                                  
# |    |    _____   ___.__.  ____ _______     / /   ______                                         
# |    |    \__  \ <   |  |_/ __ \\_  __ \   / /   /  ___/                                         
# |    |___  / __ \_\___  |\  ___/ |  | \/  / /    \___ \                                          
# |_______ \(____  // ____| \___  >.____   / /    /____  >                  .__                    
# _/  |_  \____  \/_____  ______\/ |    |  \/_____    __/__   ____    ____  |  |__    ____ _______ 
# \   __\_/ __ \  /     \ \____ \  |    |    \__  \  |  |  \ /    \ _/ ___\ |  |  \ _/ __ \\_  __ \
#  |  |  \  ___/ |  Y Y  \|  |_> > |    |___  / __ \_|  |  /|   |  \\  \___ |   Y  \\  ___/ |  | \/
#  |__|   \___  >|__|_|  /|   __/  |_______ \(____  /|____/ |___|  / \___  >|___|  / \___  >|__|   
#             \/       \/ |__|             \/     \/             \/      \/      \/      \/        


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

# Function to create and execute a layer
create_layer() {
    local layer_name="$1"       # Name of the current layer
    local layer_content="$2"    # Content for the layer
    local heredoc_delim="$3"    # Heredoc delimiter for the current layer

    echo "Creating ${layer_name}.sh..."

    # Create the temporary script
    cat <<EOF > "${layer_name}.sh"
#!/bin/bash
# Temporary script: ${layer_name}
echo "Executing ${layer_name}.sh"

${layer_content}

echo "Completed ${layer_name}.sh"
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
# Create and execute layer2
cat <<'INNERDOX' > layer2.sh
#!/bin/bash
# Temporary script: layer2
echo "Executing layer2.sh"

# User content from xed:
${content}

echo "Completed layer2.sh"
INNERDOX

chmod +x layer2.sh
./layer2.sh
rm -f layer2.sh
EOL
)

# Step 5: Create Layer 1 with Layer 2 content
layer1_content="#!/bin/bash
# Temporary script: layer1
echo \"Executing layer1.sh\"

${layer2_content}

echo \"Completed layer1.sh\""

# Copy the combined Layer 1 script to the clipboard
echo "$layer1_content" | xclip -selection clipboard

echo "Combined script copied to clipboard."

# Clean up
rm -f tempfile.txt

# Optionally, you can output the combined script to verify
# echo "$layer1_content"
