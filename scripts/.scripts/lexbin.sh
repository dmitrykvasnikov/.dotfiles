#!/bin/bash

# Default values
skip_scripts=false
create_backup=false
dry_run=false
recursive=false
name_mask="*.el"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--skip-scripts)
            skip_scripts=true
            shift
            ;;
        -b|--backup)
            create_backup=true
            shift
            ;;
        -d|--dry-run)
            dry_run=true
            shift
            ;;
        -r|--recursive)
            recursive=true
            shift
            ;;
        -n|--name)
            name_mask="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -s, --skip-scripts     Skip files that have shebang (#!) in first line"
            echo "  -b, --backup           Create backup files before modifying"
            echo "  -d, --dry-run          Show what would be done without actually modifying"
            echo "  -r, --recursive        Scan directories recursively"
            echo "  -n, --name MASK        Filename mask (default: '*.el')"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                          # Process all .el files in current dir"
            echo "  $0 -s                                       # Skip script files with shebang"
            echo "  $0 -r                                       # Process all .el files recursively"
            echo "  $0 -r -n \"*.lisp\"                          # Process all .lisp files recursively"
            echo "  $0 -s -b -r -n \"my-*.el\"                   # Skip scripts, backup, recursive, custom mask"
            echo "  $0 -d -s                                    # Dry run with script skipping"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Function to check if file has shebang
has_shebang() {
    head -n 1 "$1" | grep -q "^#!"
}

# Function to check if file has lexical-binding
has_lexical_binding() {
    head -n 1 "$1" | grep -q "lexical-binding.*:.*t"
}

# Function to process a single file
process_file() {
    local file="$1"
    local rel_path="${file#./}"
    
    # Check for shebang if skip_scripts is enabled
    if [ "$skip_scripts" = true ] && has_shebang "$file"; then
        echo "⏭️  SKIP (has shebang): $rel_path"
        return 1
    fi
    
    # Check if already has lexical-binding
    if has_lexical_binding "$file"; then
        echo "✅ EXISTS: $rel_path"
        return 2
    fi
    
    echo "📝 MODIFY: $rel_path"
    
    if [ "$dry_run" = true ]; then
        echo "   (would add: ;;; $(basename "$file") -*- lexical-binding: t -*-)"
        return 3
    fi
    
    # Create backup if requested
    if [ "$create_backup" = true ]; then
        local backup_path="$backup_dir/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        cp "$file" "$backup_path"
    fi
    
    # Create temporary file
    local tmp_file=$(mktemp)
    
    # Get first line
    local first_line=$(head -n 1 "$file")
    
    # Handle modification
    if [[ "$first_line" =~ ^#! ]]; then
        # Has shebang - add cookie on second line
        echo "$first_line" > "$tmp_file"
        echo ";;; $(basename "$file") -*- lexical-binding: t -*-" >> "$tmp_file"
        tail -n +2 "$file" >> "$tmp_file"
    else
        # No shebang - check for existing file-local variables
        if [[ "$first_line" =~ -\*- ]]; then
            # Replace existing file-local variables
            local clean_line=$(echo "$first_line" | sed -E 's/-\*-[^-]*-\*-\s*//g')
            if [[ -z "$clean_line" ]] || [[ "$clean_line" =~ ^[[:space:]]*$ ]]; then
                echo ";;; $(basename "$file") -*- lexical-binding: t -*-" > "$tmp_file"
            else
                echo "$clean_line -*- lexical-binding: t -*-" > "$tmp_file"
            fi
            tail -n +2 "$file" >> "$tmp_file"
        else
            # Normal case - add as first line
            echo ";;; $(basename "$file") -*- lexical-binding: t -*-" > "$tmp_file"
            cat "$file" >> "$tmp_file"
        fi
    fi
    
    # Replace original file
    mv "$tmp_file" "$file"
    return 3
}

# Create backup directory if needed
if [ "$create_backup" = true ] && [ "$dry_run" = false ]; then
    backup_dir="el_backups_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    echo "📁 Backup directory: $backup_dir"
elif [ "$create_backup" = true ] && [ "$dry_run" = true ]; then
    backup_dir="el_backups_<timestamp>"
    echo "🔍 DRY RUN: Would create backup directory: $backup_dir"
fi

# Collect files based on recursive flag and name mask
files_to_process=()

if [ "$recursive" = true ]; then
    # Recursive find
    while IFS= read -r file; do
        files_to_process+=("$file")
    done < <(find . -type f -name "$name_mask" ! -path "*/.*" 2>/dev/null | sort)
else
    # Current directory only
    for file in $name_mask; do
        [ -e "$file" ] && files_to_process+=("$file")
    done
fi

# Check if any files found
if [ ${#files_to_process[@]} -eq 0 ]; then
    echo "No files matching '$name_mask' found."
    exit 0
fi

# Statistics
total=0
skipped_shebang=0
already_have=0
added=0

# Process each file
for file in "${files_to_process[@]}"; do
    total=$((total + 1))
    process_file "$file"
    case $? in
        1) skipped_shebang=$((skipped_shebang + 1));;
        2) already_have=$((already_have + 1));;
        3) added=$((added + 1));;
    esac
done

# Print summary
echo ""
echo "========================================="
echo "SUMMARY:"
echo "  Files matching '$name_mask': $total"
if [ "$recursive" = true ]; then
    echo "  Mode: Recursive scan"
fi
echo "  Already had lexical-binding: $already_have"
echo "  Modified: $added"
if [ "$skip_scripts" = true ]; then
    echo "  Skipped (had shebang): $skipped_shebang"
fi
if [ "$dry_run" = true ]; then
    echo "  Mode: DRY RUN (no files were actually modified)"
fi
if [ "$create_backup" = true ] && [ "$dry_run" = false ]; then
    echo "  Backups saved to: $backup_dir"
fi
echo "========================================="
