#!/bin/bash

# ==========================================
# Script Name: make_patch.sh
# Description: Generate a single patch file containing all commits 
#              from a specified commit up to HEAD.
# ==========================================

# Initialize variables
START_COMMIT=""
GENERATE_INDIVIDUAL_PATCHES=false

# Parse arguments
# Use a temporary array to store positional arguments (like START_COMMIT)
POSITIONAL_ARGS=()
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -i|--individual)
            GENERATE_INDIVIDUAL_PATCHES=true
            shift # Consume the option
            ;;
        *) # Positional argument
            POSITIONAL_ARGS+=("$1")
            shift # Consume the argument
            ;;
    esac
done

# Restore positional arguments
set -- "${POSITIONAL_ARGS[@]}"

# 1. Check if a commit hash is provided (now it's $1 after parsing options)
if [ -z "$1" ]; then # $1 is now the first positional argument
    echo "⚠️  Error: No commit hash provided."
    echo "💡 Usage: ./make_patch.sh <commit_hash> [-i|--individual]"
    echo "💡 Example: ./make_patch.sh e9459ad"
    echo "💡 Example: ./make_patch.sh e9459ad --individual"
    exit 1
fi
START_COMMIT=$1

# 2. Verify that the current directory is inside a Git repository (moved up for early exit)
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Error: The current directory is not a Git repository."
    exit 1
fi

# Get the short hash of HEAD to use in the filename
HEAD_HASH=$(git rev-parse --short HEAD)

# 3. Verify that the provided commit hash exists
if ! git cat-file -e "${START_COMMIT}^{commit}" > /dev/null 2>&1; then
     echo "❌ Error: Cannot find the specified commit '${START_COMMIT}'."
     echo "   Please check if the hash is correct."
     exit 1
fi

if "$GENERATE_INDIVIDUAL_PATCHES"; then
    OUTPUT_DIR="patches_${START_COMMIT}_to_${HEAD_HASH}"
    echo "⏳ Generating individual patches from ${START_COMMIT} to HEAD (${HEAD_HASH}) into directory '${OUTPUT_DIR}'..."
    # Create the output directory if it doesn't exist
    mkdir -p "${OUTPUT_DIR}"
    # 4. Generate the patches (one file per commit)
    git format-patch "${START_COMMIT}..HEAD" -o "${OUTPUT_DIR}"
    OUTPUT_TARGET="${OUTPUT_DIR}" # For success message
else
    OUTPUT_FILE="patch_${START_COMMIT}_to_${HEAD_HASH}.patch"
    echo "⏳ Generating single squashed patch from ${START_COMMIT} to HEAD (${HEAD_HASH})..."
    # 4. Generate the patch (using --stdout to combine all commits into one file)
    git format-patch "${START_COMMIT}" --stdout > "${OUTPUT_FILE}"
    OUTPUT_TARGET="${OUTPUT_FILE}" # For success message
fi

# 5. Check the result of the git command and provide feedback
if [ $? -eq 0 ]; then
    echo "✅ Patch created successfully!"
    if "$GENERATE_INDIVIDUAL_PATCHES"; then
        echo "📂 Individual patch files saved in: ${OUTPUT_TARGET}"
        echo "   You can apply them using 'git am ${OUTPUT_TARGET}/*'"
    else
        echo "📂 File saved as: ${OUTPUT_TARGET}"
    fi
else
    echo "❌ Error: Failed to generate patch. Please check your Git status."
    exit 1
fi
