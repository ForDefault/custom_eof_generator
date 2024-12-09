# custom_eof_generator

**Custom EOF Generator**: A tool to dynamically embed, execute, and remove: for direct terminal launching or for temporary scripts within other Bash scripts( especially useful for loops or iterative tasks). 

**Auto-generates for both python and bash**

> Personal Note: I do not like the hassle of testing scripts... create a file, make it executable, then typing a command to launch; especially on remote devices. So I can use this to test scripts quickly and it cleans itself up afterwards. This way I can just do tests quickly. 

---

## **Overview**
This generator is ideal for scenarios where you need to launch a temporary script either directly into a terminal or another process without keeping the script permanently. It helps streamline workflows by creating, executing, and cleaning up temporary scripts dynamically.

---

## **Use Case Example**

The following example demonstrates how to use `custom_eof_generator` to process image files in a directory:

### **Example Below Workflow**
1. **Generate a list of images** in the current directory.
2. **Dynamically create a script** to process each image.
3. **Execute the script** for each file iteratively.
4. **Clean up the temporary scripts** after execution.


##### Desired Embed:
```bash
# Path to the script to be executed
SCRIPT_PATH="/home/$USER/some/folder/here.sh"

# Ensure the script runs in the directory where it was launched
cd "$(dirname "$0")"

# Sort the file list alphabetically and overwrite pic.list.txt
sort pic.list.txt -o pic.list.txt

# Get the first file from the sorted list
file=$(head -n 1 pic.list.txt)

# Copy the file name to the clipboard
echo -n "$file" | xclip -selection clipboard

# Remove the file name from the list
sed -i "1d" pic.list.txt

# Execute the script with the file name
$SCRIPT_PATH "$file"
```

##### Output by 'custom_eof_generator' to clipboard would be:
```
#!/bin/bash

            cat <<'INNERDOX' > layer2.sh
#!/bin/bash


# Path to the script to be executed
SCRIPT_PATH="/home/$USER/some/folder/here.sh"

# Ensure the script runs in the directory where it was launched
cd "$(dirname "$0")"

# Sort the file list alphabetically and overwrite pic.list.txt
sort pic.list.txt -o pic.list.txt

# Get the first file from the sorted list
file=$(head -n 1 pic.list.txt)

# Copy the file name to the clipboard
echo -n "$file" | xclip -selection clipboard

# Remove the file name from the list
sed -i "1d" pic.list.txt

# Execute the script with the file name
$SCRIPT_PATH "$file"
INNERDOX
            chmod +x layer2.sh
            ./layer2.sh
            rm -f layer2.sh

```
##### Use in script loop for pictures:
```
##### Used in a script like

#!/bin/bash
# Get the directory where the script is called
DIR="$(pwd)"

# Run everything from the directory
cd "$DIR"

# Generate the list of image files
find . -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf "%f\n" > pic.list.txt

# Confirm the list has been created
if [ ! -s pic.list.txt ]; then
    echo "No images found in the current directory."
    exit 1
fi
echo "Image list created: pic.list.txt"

# Outer loop: Continue while pic.list.txt is not empty
while [ -s pic.list.txt ]; do
    # If the list is empty, break out of the loop
    if [ ! -s pic.list.txt ]; then
        break
    fi

    # Dynamically create the EOF script
#!/bin/bash

            cat <<'INNERDOX' > layer2.sh
#!/bin/bash


# Path to the script to be executed
SCRIPT_PATH="/home/$USER/some/folder/here.sh"

# Ensure the script runs in the directory where it was launched
cd "$(dirname "$0")"

# Sort the file list alphabetically and overwrite pic.list.txt
sort pic.list.txt -o pic.list.txt

# Get the first file from the sorted list
file=$(head -n 1 pic.list.txt)

# Copy the file name to the clipboard
echo -n "$file" | xclip -selection clipboard

# Remove the file name from the list
sed -i "1d" pic.list.txt

# Execute the script with the file name
$SCRIPT_PATH "$file"
INNERDOX
            chmod +x layer2.sh
            ./layer2.sh
            rm -f layer2.sh

done

echo "All images processed. Exiting."
```
