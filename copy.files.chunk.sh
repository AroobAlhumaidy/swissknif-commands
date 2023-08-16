#!/bin/bash
# By: Aroob Alhumaidy

# Check if the right number of arguments is provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <source_path> <destination_path>"
  exit 1
fi

# Assign the source and destination paths from command-line arguments
SOURCE_PATH="$1"
DESTINATION_PATH="$2"

# Check if list.txt exists
if [ ! -f "list.txt" ]; then
  echo "list.txt not found!"
  exit 1
fi

# Initialize an empty string to hold file names not found
not_found_files=""

# Read file names from list.txt and copy them from source to destination
while IFS= read -r file_name; do
  # Removing any wildcards (*) from the file name
  file_name=${file_name%%\**}
  
  # Finding the files in the source path
  found_files=$(find "$SOURCE_PATH" -type f -name "$file_name")
  
  if [ -n "$found_files" ]; then
    # Copy the found files
    cp $found_files "$DESTINATION_PATH"
    echo "Copied $file_name to $DESTINATION_PATH"
  else
    # Add the file name to the not_found_files string
    not_found_files+="$file_name\n"
  fi
done < "list.txt"

echo "Copying done!"

# Print file names that were not found
if [ -n "$not_found_files" ]; then
  echo -e "Files not found:"
  echo -e "$not_found_files"
else
  echo "All files were found and copied."
fi
