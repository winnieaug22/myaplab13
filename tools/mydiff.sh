#!/usr/bin/env bash

set -u

DIR_A="${1:-}"
DIR_B="${2:-}"

if [[ -z "$DIR_A" || -z "$DIR_B" ]]; then
    echo "Usage: $0 <dir_A> <dir_B>"
    exit 1
fi

if [[ ! -d "$DIR_A" ]]; then
    echo "Error: dir_A does not exist or is not a directory: $DIR_A"
    exit 1
fi

if [[ ! -d "$DIR_B" ]]; then
    echo "Error: dir_B does not exist or is not a directory: $DIR_B"
    exit 1
fi

same_count=0
diff_count=0
missing_count=0

declare -a diff_rel_paths
declare -a diff_file_a
declare -a diff_file_b
declare -a missing_rel_paths

while IFS= read -r -d '' file_a; do
    rel_path="${file_a#"$DIR_A"/}"
    file_b="$DIR_B/$rel_path"

    if [[ ! -e "$file_b" ]]; then
        missing_rel_paths+=("$rel_path")
        ((missing_count++))
        continue
    fi

    if [[ ! -f "$file_b" ]]; then
        missing_rel_paths+=("$rel_path")
        ((missing_count++))
        continue
    fi

    if cmp -s "$file_a" "$file_b"; then
        ((same_count++))
    else
        diff_rel_paths+=("$rel_path")
        diff_file_a+=("$file_a")
        diff_file_b+=("$file_b")
        ((diff_count++))
    fi
done < <(find "$DIR_A" -type f -print0)

echo "Comparison finished."
echo "  Same: $same_count"
echo "  Different: $diff_count"
echo "  Missing or not comparable in B: $missing_count"
echo

if (( missing_count > 0 )); then
    echo "Files missing or not comparable in B:"
    for path in "${missing_rel_paths[@]}"; do
        echo "  $path"
    done
    echo
fi

if (( diff_count == 0 )); then
    echo "No different files found."
    exit 0
fi

echo "Different files:"
for i in "${!diff_rel_paths[@]}"; do
    printf "  [%d] %s\n" "$((i + 1))" "${diff_rel_paths[$i]}"
done
echo
echo "Enter one or more numbers separated by spaces to open with vimdiff."
echo "You can also use ranges such as 1-3 7 9-10."
echo "Enter 'a' to open all, or 'q' to quit."

read -r -p "Selection: " selection

if [[ "$selection" == "q" || "$selection" == "Q" ]]; then
    echo "Aborted by user."
    exit 0
fi

declare -a selected_indices

add_index() {
    local idx="$1"
    local existing
    for existing in "${selected_indices[@]}"; do
        if [[ "$existing" -eq "$idx" ]]; then
            return
        fi
    done
    selected_indices+=("$idx")
}

if [[ "$selection" == "a" || "$selection" == "A" ]]; then
    for i in "${!diff_rel_paths[@]}"; do
        selected_indices+=("$i")
    done
else
    for token in $selection; do
        if [[ "$token" =~ ^[0-9]+$ ]]; then
            num="$token"
            if (( num >= 1 && num <= diff_count )); then
                add_index "$((num - 1))"
            else
                echo "Warning: index out of range: $num"
            fi
        elif [[ "$token" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            start="${BASH_REMATCH[1]}"
            end="${BASH_REMATCH[2]}"

            if (( start > end )); then
                tmp="$start"
                start="$end"
                end="$tmp"
            fi

            for ((num = start; num <= end; num++)); do
                if (( num >= 1 && num <= diff_count )); then
                    add_index "$((num - 1))"
                else
                    echo "Warning: index out of range: $num"
                fi
            done
        else
            echo "Warning: invalid token ignored: $token"
        fi
    done
fi

if (( ${#selected_indices[@]} == 0 )); then
    echo "No files selected."
    exit 0
fi

for idx in "${selected_indices[@]}"; do
    echo "Opening vimdiff for: ${diff_rel_paths[$idx]}"
    vimdiff "${diff_file_a[$idx]}" "${diff_file_b[$idx]}"
done
