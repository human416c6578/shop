import os
import glob

# Function to replace content between fff.bmp and ffff.bmp with content from a.txt
def replace_content_between_fff_ffff(input_file, output_file, a_file):
    # Read content from a.txt
    with open(a_file, 'r') as a:
        replacement_lines = a.readlines()

    # Read content from original file
    with open(input_file, 'r') as f:
        lines = f.readlines()

    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        
        # If we find "fff.bmp", start replacement
        if line == "fff.bmp":
            # Skip fff.bmp line and all lines until finding ffff.bmp
            while i < len(lines) and "ffff.bmp" not in lines[i]:
                i += 1
            
            # Add content from a.txt
            new_lines.extend(replacement_lines)
            
            # Add blank line before ffff.bmp
            new_lines.append('\n')
            
            # Add ffff.bmp line if found
            if i < len(lines) and "ffff.bmp" in lines[i]:
                new_lines.append(lines[i])
                i += 1
        else:
            # If not fff.bmp, keep original line
            new_lines.append(lines[i])
            i += 1

    # Write new content to output file
    with open(output_file, 'w') as f:
        f.writelines(new_lines)

# Define file paths
directory = r"PATH OF YOUR DIRECTORY" #Adjust according to the path of your directory.
modified_directory = os.path.join(directory, "modificados")
replacement_file = os.path.join(directory, "a.txt")

# Check if a.txt exists
if not os.path.exists(replacement_file):
    print(f"Error: File {replacement_file} not found.")
else:
    # Search for all .smd files in directory
    smd_files = glob.glob(os.path.join(directory, "*.smd"))
    
    # Process each .smd file found
    for input_file in smd_files:
        # Get only the filename (without path)
        filename = os.path.basename(input_file)
        
        # Define output file path in 'modificados' folder
        output_file = os.path.join(modified_directory, filename)
        
        # Process the file
        replace_content_between_fff_ffff(input_file, output_file, replacement_file)
        print(f"File {filename} processed and saved to {output_file}")

    print("\nProcessing completed! All files have been modified.") 