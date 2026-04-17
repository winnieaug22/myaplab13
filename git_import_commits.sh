#!/bin/bash

# ==========================================
# Script Name: git_import_commits.sh
# Description: Applies commits from patch files (using 'git am') or a Git bundle (using 'git pull').
# ==========================================

INPUT_PATH="$1" # Renamed from PATCH_FILE to INPUT_PATH as it can be a file or directory

# 1. Check if an input path is provided
if [ -z "$INPUT_PATH" ]; then
    echo "⚠️  Error: No patch file or directory provided."
    echo "💡 Usage: ./git_import_commits.sh <patch_file.patch | patch_directory | bundle_file.bundle>"
    echo "💡 Example: ./git_import_commits.sh patch_e9459ad_to_863fe74.patch"
    echo "💡 Example: ./git_import_commits.sh patches_e9459ad_to_863fe74"
    echo "💡 Example: ./git_import_commits.sh bundle_e9459ad_to_863fe74.bundle"
    exit 1
fi

# 2. Verify that the current directory is inside a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Error: The current directory is not a Git repository."
    exit 1
fi

# 3. Determine the input type and apply accordingly
IS_FILE=false
IS_DIR=false
IS_BUNDLE=false

if [ -d "$INPUT_PATH" ]; then
    IS_DIR=true
elif [ -f "$INPUT_PATH" ]; then
    if [[ "$INPUT_PATH" == *.bundle ]]; then
        IS_BUNDLE=true
    else
        # Assume it's a patch file by default if it's not a bundle
        IS_FILE=true
    fi
else
    echo "❌ Error: Input path '${INPUT_PATH}' is not a valid file or directory."
    exit 1
fi

if "$IS_BUNDLE"; then
    echo "📦 Detected Git bundle file. Applying via fetch/merge..."
    
    echo "🔍 Verifying bundle integrity..."
    if ! git bundle verify "$INPUT_PATH"; then
        echo "❌ Error: Bundle file '${INPUT_PATH}' is corrupt or invalid."
        exit 1
    fi

    # Get the primary ref from the bundle (e.g., 'master' from 'refs/heads/master')
    BUNDLE_REF_FULL=$(git bundle list-heads "$INPUT_PATH" | head -n 1 | awk '{print $2}')
    if [ -z "$BUNDLE_REF_FULL" ]; then
        echo "❌ Error: Could not find any refs (branches) inside the bundle."
        exit 1
    fi
    BUNDLE_BRANCH_NAME=$(basename "$BUNDLE_REF_FULL")

    echo "⏳ Fetching from bundle ('$BUNDLE_BRANCH_NAME') and merging into current branch..."
    # 'git pull' is a convenient way to do fetch + merge.
    # First, try a fast-forward only merge, which is the cleanest way.
    if git pull --ff-only "$INPUT_PATH" "$BUNDLE_BRANCH_NAME"; then
        echo "✅ Bundle applied successfully with a fast-forward merge!"
        echo "   Commit history is now identical to the source."
    # If ff-only fails, it means the histories have diverged. Do a regular merge.
    elif git pull "$INPUT_PATH" "$BUNDLE_BRANCH_NAME"; then
        echo "✅ Bundle applied successfully with a merge commit."
        echo "   A merge commit was created to integrate the changes."
    else
        echo "❌ Error: Failed to apply bundle."
        echo "   This could be due to merge conflicts."
        echo "   Please resolve the conflicts and commit, or run 'git merge --abort'."
        exit 1
    fi
elif "$IS_FILE" || "$IS_DIR"; then
    echo "⏳ Applying patches from '${INPUT_PATH}' via 'git am'..."
    
    AM_ARGS=()
    if "$IS_FILE"; then
        AM_ARGS=("$INPUT_PATH")
    elif "$IS_DIR"; then
        shopt -s nullglob
        # Use ls -v to sort patches numerically, ensuring correct application order
        PATCH_FILES=($(ls -v "$INPUT_PATH"/*.patch 2>/dev/null))
        shopt -u nullglob

        if [ "${#PATCH_FILES[@]}" -eq 0 ]; then
            echo "❌ Error: Directory '${INPUT_PATH}' contains no .patch files."
            exit 1
        fi
        AM_ARGS=("${PATCH_FILES[@]}")
    fi
    
    if git am "${AM_ARGS[@]}"; then
        echo "✅ Patches applied successfully!"
        echo "   Note: New commit hashes have been generated. You can verify with 'git log'."
    else
        echo "❌ Error: Failed to apply patch(es)."
        echo "   Git may have stopped due to conflicts. Resolve them and run 'git am --continue',"
        echo "   or cancel with 'git am --abort'."
        echo "   Tip: If 'git am' seems to do nothing, try running 'git am --abort' first to clear any old state."
        exit 1
    fi
fi