# custom_eof_generator

**Custom EOF Generator**: A tool to dynamically embed, execute, and remove: for direct terminal launching or for temporary scripts within other Bash scripts( especially useful for loops or iterative tasks).

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

##### Script wanting embedded:
```
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

##### Output to clipboard would be:
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
