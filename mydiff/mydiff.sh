#!/usr/bin/env bash

# ==========================================
# Script Name: mydiff.sh
# Description: Compare two directories or a list of files between two directories.
#              Supports interactive vimdiff selection and copying files preserving structure.
# ==========================================

set -u

# --- Configuration & Variables ---
COPY_MODE=false
GOLDEN_OUT_DIR="golden"
MODIFIED_OUT_DIR="modified"

# --- Parse Arguments ---
if [[ "${1:-}" == "-c" || "${1:-}" == "--copy" ]]; then
    COPY_MODE=true
    shift
fi

GOLDEN_DIR="${1:-}"
MODIFIED_DIR="${2:-}"
FILELIST="${3:-}"

# --- Validation ---
if [[ -z "$GOLDEN_DIR" || -z "$MODIFIED_DIR" ]]; then
    echo "Usage: $0 [-c|--copy] <golden_dir> <modified_dir> [filelist]"
    echo "  -c, --copy   Copy matched/diff files to './${GOLDEN_OUT_DIR}' and './${MODIFIED_OUT_DIR}' instead of vimdiff"
    exit 1
fi

for dir in "$GOLDEN_DIR" "$MODIFIED_DIR"; do
    if [[ ! -d "$dir" ]]; then
        echo "❌ Error: Directory does not exist: $dir"
        exit 1
    fi
done

if [[ -n "$FILELIST" && ! -f "$FILELIST" ]]; then
    echo "❌ Error: Filelist does not exist or is not a file: $FILELIST"
    exit 1
fi

# --- Statistics & State ---
same_count=0
diff_count=0
missing_count=0

# Arrays to hold files that will be processed (copied or compared)
declare -a target_rel_paths
declare -a target_file_a
declare -a target_file_b
declare -a target_status
declare -a missing_in_modified_paths

# --- Core Logic ---
echo "🔍 Comparing directories..."

if [[ -n "$FILELIST" ]]; then
    # Mode 1: Compare files strictly based on the provided filelist
    while IFS= read -r rel_path || [[ -n "$rel_path" ]]; do
        # Skip empty lines
        [[ -z "$rel_path" ]] && continue

        file_a="$GOLDEN_DIR/$rel_path"
        file_b="$MODIFIED_DIR/$rel_path"

        target_rel_paths+=("$rel_path")
        target_file_a+=("$file_a")
        target_file_b+=("$file_b")

        if [[ ! -f "$file_a" && ! -f "$file_b" ]]; then
            target_status+=("Missing in both")
            ((missing_count++))
        elif [[ ! -f "$file_a" ]]; then
            target_status+=("Missing in Golden")
            ((missing_count++))
        elif [[ ! -f "$file_b" ]]; then
            target_status+=("Missing in Modified")
            ((missing_count++))
        elif cmp -s "$file_a" "$file_b"; then
            target_status+=("Same")
            ((same_count++))
        else
            target_status+=("Different")
            ((diff_count++))
        fi
    done < "$FILELIST"
else
    # Mode 2: Recursively find and compare all files in GOLDEN_DIR against MODIFIED_DIR
    while IFS= read -r -d '' file_a; do
        rel_path="${file_a#"$GOLDEN_DIR"/}"
        file_b="$MODIFIED_DIR/$rel_path"

        if [[ ! -f "$file_b" ]]; then
            missing_in_modified_paths+=("$rel_path")
            ((missing_count++))
            continue
        fi

        if cmp -s "$file_a" "$file_b"; then
            ((same_count++))
        else
            target_rel_paths+=("$rel_path")
            target_file_a+=("$file_a")
            target_file_b+=("$file_b")
            target_status+=("Different")
            ((diff_count++))
        fi
    done < <(find "$GOLDEN_DIR" -type f -print0)
fi

# --- Summary Report ---
echo "📊 Comparison finished."
echo "  ✅ Same: $same_count"
echo "  ⚠️  Different: $diff_count"
if [[ -n "$FILELIST" ]]; then
    echo "  ❌ Missing: $missing_count"
else
    echo "  ❌ Missing or not comparable in Modified: $missing_count"
fi
echo

if (( ${#missing_in_modified_paths[@]} > 0 )); then
    echo "📄 Files missing or not comparable in Modified:"
    for path in "${missing_in_modified_paths[@]}"; do
        echo "  - $path"
    done
    echo
fi

# --- Action: Copy Mode ---
if [[ "$COPY_MODE" == true ]]; then
    echo "📂 Starting copy process..."
    copied_count=0
    for i in "${!target_rel_paths[@]}"; do
        rel_path="${target_rel_paths[$i]}"
        file_a="${target_file_a[$i]}"
        file_b="${target_file_b[$i]}"

        if [[ -f "$file_a" ]]; then
            mkdir -p "${GOLDEN_OUT_DIR}/$(dirname "$rel_path")"
            cp "$file_a" "${GOLDEN_OUT_DIR}/$rel_path"
        fi

        if [[ -f "$file_b" ]]; then
            mkdir -p "${MODIFIED_OUT_DIR}/$(dirname "$rel_path")"
            cp "$file_b" "${MODIFIED_OUT_DIR}/$rel_path"
        fi
        ((copied_count++))
    done

    if (( copied_count > 0 )); then
        echo "✅ Successfully copied $copied_count files (maintaining structure) into './${GOLDEN_OUT_DIR}' and './${MODIFIED_OUT_DIR}'."
    else
        echo "⚠️  No files were copied."
    fi
    exit 0
fi

# --- Action: Interactive Vimdiff Mode ---
if (( ${#target_rel_paths[@]} == 0 )); then
    echo "🎉 No selectable files found. Everything matches!"
    exit 0
fi

declare -a selected_indices

# Helper function to avoid duplicate selections
add_index() {
    local idx="$1"
    local existing
    for existing in "${selected_indices[@]}"; do
        [[ "$existing" -eq "$idx" ]] && return
    done
    selected_indices+=("$idx")
}

while true; do
    if [[ -n "$FILELIST" ]]; then
        echo "📑 Files in list:"
    else
        echo "📑 Different files:"
    fi
    for i in "${!target_rel_paths[@]}"; do
        printf "  [%d] %-16s %s\n" "$((i + 1))" "[${target_status[$i]}]" "${target_rel_paths[$i]}"
    done
    echo
    echo "💡 Enter one or more numbers separated by spaces to open with vimdiff."
    echo "💡 You can also use ranges such as '1-3 7 9-10'."
    echo "💡 Enter 'a' (or 's') to open all sequentially, or 'q' to quit."

    read -r -p "👉 Selection: " selection

    # Quit condition
    if [[ "${selection,,}" == "q" ]]; then
        echo "👋 Exiting."
        exit 0
    fi

    selected_indices=()

    # Select all
    if [[ "${selection,,}" == "a" || "${selection,,}" == "s" ]]; then
        for i in "${!target_rel_paths[@]}"; do
            selected_indices+=("$i")
        done
    else
        # Parse individual tokens
        for token in $selection; do
            if [[ "$token" =~ ^[0-9]+$ ]]; then
                num="$token"
                if (( num >= 1 && num <= ${#target_rel_paths[@]} )); then
                    add_index "$((num - 1))"
                else
                    echo "⚠️  Warning: index out of range: $num"
                fi
            elif [[ "$token" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                start="${BASH_REMATCH[1]}"
                end="${BASH_REMATCH[2]}"

                # Swap if start is greater than end
                if (( start > end )); then
                    tmp="$start"
                    start="$end"
                    end="$tmp"
                fi

                for ((num = start; num <= end; num++)); do
                    if (( num >= 1 && num <= ${#target_rel_paths[@]} )); then
                        add_index "$((num - 1))"
                    else
                        echo "⚠️  Warning: index out of range: $num"
                    fi
                done
            else
                echo "⚠️  Warning: invalid token ignored: $token"
            fi
        done
    fi

    if (( ${#selected_indices[@]} == 0 )); then
        echo "⚠️  No valid files selected. Please try again."
        continue
    fi

    # Open selected files in vimdiff
    for idx in "${selected_indices[@]}"; do
        read -r -p "🚀 Open vimdiff for: ${target_rel_paths[$idx]}? [Y/n/q] " ans
        if [[ "${ans,,}" == "q" ]]; then
            echo "🛑 Stopping current batch."
            break
        elif [[ "${ans,,}" == "n" ]]; then
            echo "⏭️  Skipping..."
            continue
        fi
        vimdiff "${target_file_a[$idx]}" "${target_file_b[$idx]}"
    done
    
    echo
    echo "--- ✅ Finished checking selected files ---"
    echo
done
