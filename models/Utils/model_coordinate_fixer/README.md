# SMD File Content Replacer

This script was created to automate the process of replacing specific content in SMD files. It's particularly useful when you need to replace multiple sections of content between specific markers in multiple files.

## Purpose

The script was created to fix issues with model texture coordinates in SMD files:
1. It can be used to fix visual artifacts in any part of the model (fingers, arms, legs, etc.)
2. The script adjusts hitbox coordinates within the .bmp files
3. This script automates the process of updating these coordinates across multiple SMD files

## How it Works

1. The script looks for all `.smd` files in the specified directory
2. For each file, it:
   - Reads the content
   - Finds sections marked by `fff.bmp` and `ffff.bmp`
   - Replaces the content between these markers with the content from `a.txt`
   - Adds a blank line before `ffff.bmp`
   - Saves the modified file in the "modificados" folder

## Usage

1. Place your SMD files in the main directory
2. Create a file named `a.txt` with the content you want to use as replacement
3. Create a folder named "modificados" in the same directory
4. Run the script
5. Modified files will be saved in the "modificados" folder

## File Structure

```
model_coordinate_fixer/
├── *.smd files
├── a.txt
├── modificados/
└── main.py
```

## Output

The script will process all SMD files and create modified versions in the "modificados" folder, maintaining the original filenames but with the updated content.

## Technical Details

The script specifically targets the texture coordinates of `FFF.bmp` in the model files. The original issue was caused by incorrect hitbox coordinates in the BMP file, which resulted in a black border appearing at the fingernail tip. By updating these coordinates through the script, the visual artifact is removed while maintaining the proper model structure.

**Important:** If you want to correct hitbox coordinates for other BMP textures besides `FFF.bmp`, simply modify the BMP filenames directly in the code, replacing `fff.bmp` and `ffff.bmp` with the names of the desired textures. This makes the script flexible enough to be used with any texture, not just the finger model.

While this script was initially created to fix the finger model's texture coordinates, it can also be used to fix similar issues in other parts of the model. For example:
- Texture misalignments in arms
- Visual glitches in legs
- Any other part of the model that needs coordinate adjustments

The script's flexibility allows it to be used for any part of the model where you need to update hitbox coordinates within BMP files.
