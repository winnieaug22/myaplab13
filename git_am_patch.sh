#!/bin/bash

# ==========================================
# Script Name: git_am_patch.sh
# Description: Applies Git patch files or a directory of patches using 'git am', with a prior check.
# ==========================================

INPUT_PATH="$1" # Renamed from PATCH_FILE to INPUT_PATH as it can be a file or directory

# 1. Check if an input path is provided
if [ -z "$INPUT_PATH" ]; then
    echo "⚠️  Error: No patch file or directory provided."
    echo "💡 Usage: ./git_am_patch.sh <patch_file.patch | patch_directory>"
    echo "💡 Example: ./git_am_patch.sh patch_e9459ad_to_863fe74.patch"
    echo "💡 Example: ./git_am_patch.sh patches_e9459ad_to_863fe74"
    exit 1
fi

# 2. Determine if the input is a file or a directory
IS_FILE=false
IS_DIR=false

if [ -f "$INPUT_PATH" ]; then
    IS_FILE=true
elif [ -d "$INPUT_PATH" ]; then
    IS_DIR=true
else
    echo "❌ Error: Input path '${INPUT_PATH}' is neither a file nor a directory."
    exit 1
fi

# Prepare arguments for git am
AM_ARGS=()
if "$IS_FILE"; then
    AM_ARGS=("$INPUT_PATH")
elif "$IS_DIR"; then
    # Enable nullglob to handle cases where no .patch files are found
    shopt -s nullglob
    # Use ls -v to sort patches numerically to ensure correct order
    PATCH_FILES=($(ls -v "$INPUT_PATH"/*.patch 2>/dev/null))
    shopt -u nullglob # Disable nullglob afterwards

    if [ "${#PATCH_FILES[@]}" -eq 0 ]; then
        echo "❌ Error: Directory '${INPUT_PATH}' contains no .patch files."
        exit 1
    fi
    AM_ARGS=("${PATCH_FILES[@]}")
fi

# 3. Verify that the current directory is inside a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Error: The current directory is not a Git repository."
    exit 1
fi

# The pre-check with 'git apply --check' has been removed because it is not reliable
# for a series of patches that depend on each other. 'git am' itself will stop
# if a patch cannot be applied, which is a more robust way to handle this.

echo "⏳ Applying patches from '${INPUT_PATH}'..."
if git am "${AM_ARGS[@]}"; then
    echo "✅ Patch applied successfully!"
    echo "   You can now verify the changes with 'git log' or 'git status'."
else
    echo "❌ Error: Failed to apply patch."
    echo "   Git stopped due to conflicts or other issues."
    echo "   You can resolve conflicts and run 'git am --continue',"
    echo "   or abort the process with 'git am --abort'."
    echo "   Tip: If 'git am' seems to do nothing, try running 'git am --abort' first to clear any old state."
    exit 1
fi