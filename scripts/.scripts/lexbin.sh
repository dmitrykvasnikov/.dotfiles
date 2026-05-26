#!/bin/bash

# Check each .el file in current directory
for file in *.el; do
    # Skip if no .el files exist
    [ -e "$file" ] || continue
    
    # Check if file already has lexical-binding cookie in first line
    if ! head -n 1 "$file" | grep -q "lexical-binding.*:.*t"; then
        echo "Adding lexical-binding cookie to: $file"
        
        # Create temporary file
        tmp_file=$(mktemp)
        
        # Add the cookie as first line, preserve rest of file
        echo ";;; $file -*- lexical-binding: t; -*-" > "$tmp_file"
        
        # Check if original first line had a shebang or other important first line
        first_line=$(head -n 1 "$file")
        if [[ "$first_line" =~ ^#! ]]; then
            # Preserve shebang line by putting it back at top
            echo "$first_line" > "$tmp_file"
            echo ";;; $file -*- lexical-binding: t; -*-" >> "$tmp_file"
            tail -n +2 "$file" | tail -n +2 >> "$tmp_file"
        else
            # Append original content starting from line 1
            cat "$file" >> "$tmp_file"
        fi
        
        # Replace original file
        mv "$tmp_file" "$file"
    else
        echo "Already has lexical-binding: $file"
    fi
done

echo "Done!"
