#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

DEFAULT_FILE="src/main.rs"
AUTO_RESET=1
LIST_AFTER=1
SHOW_DIFF=0
DRY_RUN=0
PADDING=3
TEMPLATE_MODE="rust-main"

info() {
    printf "[INFO] %s\n" "$1"
}

success() {
    printf "[OK] %s\n" "$1"
}

warn() {
    printf "[WARN] %s\n" "$1" >&2
}

error() {
    printf "[ERROR] %s\n" "$1" >&2
}

die() {
    error "$1"
    exit 1
}

show_help() {
    cat <<EOF
Usage:
  $SCRIPT_NAME [options] [file]

Description:
  Create a numbered snapshot copy of a file like:
    src/main.rs -> src/main_001.rs, src/main_002.rs, ...

  By default, the source file is reset after snapshot creation.

Arguments:
  file                      Source file to snapshot
                            default: $DEFAULT_FILE

Options:
  --no-reset                Do not rewrite the source file after snapshot
  --template <mode>         Reset template mode
                            modes: rust-main, empty
  --padding <n>             Number padding width (default: $PADDING)
  --no-list                 Do not list directory contents after snapshot
  --diff                    Show diff between source and created snapshot
  --dry-run                 Print actions without changing files
  -h, --help                Show this help message

Examples:
  $SCRIPT_NAME
  $SCRIPT_NAME src/main.rs
  $SCRIPT_NAME src/lib.rs --no-reset
  $SCRIPT_NAME src/main.rs --template empty
  $SCRIPT_NAME src/main.rs --padding 4
EOF
}

require_file() {
    local file="$1"
    [[ -f "$file" ]] || die "File not found: $file"
}

require_parent_dir() {
    local file="$1"
    local dir
    dir="$(dirname "$file")"
    [[ -d "$dir" ]] || die "Directory not found: $dir"
}

is_positive_integer() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

get_parts() {
    local file="$1"
    FILE_DIR="$(dirname "$file")"
    FILE_BASE="$(basename "$file")"

    if [[ "$FILE_BASE" == *.* ]]; then
        FILE_NAME="${FILE_BASE%.*}"
        FILE_EXT="${FILE_BASE##*.}"
    else
        FILE_NAME="$FILE_BASE"
        FILE_EXT=""
    fi
}

build_snapshot_path() {
    local index="$1"
    local padded
    printf -v padded "%0${PADDING}d" "$index"

    if [[ -n "$FILE_EXT" ]]; then
        SNAPSHOT_FILE="$FILE_DIR/${FILE_NAME}_${padded}.${FILE_EXT}"
    else
        SNAPSHOT_FILE="$FILE_DIR/${FILE_NAME}_${padded}"
    fi
}

next_index() {
    local max=0
    local file candidate suffix num pattern

    if [[ -n "$FILE_EXT" ]]; then
        pattern="$FILE_DIR/${FILE_NAME}_*.${FILE_EXT}"
    else
        pattern="$FILE_DIR/${FILE_NAME}_*"
    fi

    shopt -s nullglob
    for file in $pattern; do
        candidate="$(basename "$file")"

        if [[ -n "$FILE_EXT" ]]; then
            suffix="${candidate#"${FILE_NAME}_"}"
            num="${suffix%.${FILE_EXT}}"
        else
            num="${candidate#"${FILE_NAME}_"}"
        fi

        if [[ "$num" =~ ^[0-9]+$ ]]; then
            (( num > max )) && max="$num"
        fi
    done
    shopt -u nullglob

    printf "%d" "$((max + 1))"
}

write_template_rust_main() {
    local target="$1"

    cat > "$target" <<'EOF'
use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
    println!("\n");



    end_message("0.1.0");
    Ok(())
}

fn end_message(version: &str) {
    println!("\n 私の夢, トヨタのプログラマーになりたいです。");
    println!(" この目標を達成するまで、毎日昨日よりも良いコードを書きます。");
    println!(" ラミン あなたは本当に素晴らしい。また会いましょう。{version}\n");
}
EOF
}

write_template_empty() {
    local target="$1"
    : > "$target"
}

reset_source_file() {
    local target="$1"

    case "$TEMPLATE_MODE" in
        rust-main)
            write_template_rust_main "$target"
            ;;
        empty)
            write_template_empty "$target"
            ;;
        *)
            die "Unsupported template mode: $TEMPLATE_MODE"
            ;;
    esac
}

show_diff_if_possible() {
    local left="$1"
    local right="$2"

    if [[ "$SHOW_DIFF" -ne 1 ]]; then
        return 0
    fi

    if command -v diff >/dev/null 2>&1; then
        info "Diff between snapshot and current source:"
        diff -u "$left" "$right" || true
    else
        warn "'diff' command not found; skipping diff output."
    fi
}

list_directory() {
    local dir="$1"
    [[ "$LIST_AFTER" -eq 1 ]] || return 0
    info "Files in $dir:"
    ls "$dir"
}

run() {
    local source_file="${1:-$DEFAULT_FILE}"
    local index

    require_parent_dir "$source_file"
    require_file "$source_file"
    get_parts "$source_file"

    index="$(next_index)"
    build_snapshot_path "$index"

    [[ ! -e "$SNAPSHOT_FILE" ]] || die "Snapshot already exists: $SNAPSHOT_FILE"

    if [[ "$DRY_RUN" -eq 1 ]]; then
        info "[dry-run] Would copy: $source_file -> $SNAPSHOT_FILE"
        if [[ "$AUTO_RESET" -eq 1 ]]; then
            info "[dry-run] Would reset source file using template: $TEMPLATE_MODE"
        else
            info "[dry-run] Source reset disabled"
        fi
        return 0
    fi

    cp "$source_file" "$SNAPSHOT_FILE"
    success "Created snapshot: $SNAPSHOT_FILE"

    if [[ "$AUTO_RESET" -eq 1 ]]; then
        reset_source_file "$source_file"
        success "Reset source file: $source_file"
    else
        info "Source reset skipped"
    fi

    list_directory "$FILE_DIR"
    show_diff_if_possible "$SNAPSHOT_FILE" "$source_file"
}

POSITIONAL_FILE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-reset)
            AUTO_RESET=0
            shift
            ;;
        --template)
            [[ $# -ge 2 ]] || die "Missing value for --template"
            TEMPLATE_MODE="$2"
            shift 2
            ;;
        --padding)
            [[ $# -ge 2 ]] || die "Missing value for --padding"
            is_positive_integer "$2" || die "--padding must be a positive integer"
            PADDING="$2"
            shift 2
            ;;
        --no-list)
            LIST_AFTER=0
            shift
            ;;
        --diff)
            SHOW_DIFF=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            die "Unknown option: $1"
            ;;
        *)
            if [[ -n "$POSITIONAL_FILE" ]]; then
                die "Only one source file may be provided"
            fi
            POSITIONAL_FILE="$1"
            shift
            ;;
    esac
done

run "${POSITIONAL_FILE:-$DEFAULT_FILE}"
