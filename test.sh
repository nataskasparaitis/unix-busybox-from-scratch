#!/bin/bash
set -euo pipefail

echo "=== BusyBox Full Applet Test ==="

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "hello world" > "$TMP_DIR/file.txt"

printf "\n%-30s %-10s\n" "COMMAND" "EXIT_CODE"
printf "%-30s %-10s\n" "-------" "---------"

run_and_report() {
    name="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        code=0
    else
        code=$?
    fi

    printf "%-30s %-10s\n" "$name" "$code"
}

for path in /bin/bb-*; do
    cmd=$(basename "$path")
    applet="${cmd#bb-}"

    case "$applet" in
        '['|'[[')
            echo "$cmd skipped shell builtin style applet"
            ;;
        ls)
            run_and_report "$cmd" "$path" "$TMP_DIR"
            ;;
        cat)
            run_and_report "$cmd" "$path" "$TMP_DIR/file.txt"
            ;;
        echo)
            run_and_report "$cmd" "$path" "test"
            ;;
        cp)
            run_and_report "$cmd" "$path" \
                "$TMP_DIR/file.txt" \
                "$TMP_DIR/file-copy.txt"
            ;;
        mv)
            touch "$TMP_DIR/mv-src"
            run_and_report "$cmd" "$path" \
                "$TMP_DIR/mv-src" \
                "$TMP_DIR/mv-dst"
            ;;
        rm)
            touch "$TMP_DIR/rm-test"
            run_and_report "$cmd" "$path" "$TMP_DIR/rm-test"
            ;;
        mkdir)
            run_and_report "$cmd" "$path" "$TMP_DIR/testdir"
            ;;
        rmdir)
            mkdir -p "$TMP_DIR/testdir2"
            run_and_report "$cmd" "$path" "$TMP_DIR/testdir2"
            ;;
        touch)
            run_and_report "$cmd" "$path" "$TMP_DIR/newfile"
            ;;
        grep)
            run_and_report "$cmd" "$path" \
                "hello" \
                "$TMP_DIR/file.txt"
            ;;
        head|tail)
            run_and_report "$cmd" "$path" "$TMP_DIR/file.txt"
            ;;
        pwd|date|uname|whoami|true|false|sync)
            run_and_report "$cmd" "$path"
            ;;
        *)
            # generic fallback
            run_and_report "$cmd" "$path" --help
            ;;
    esac
done

echo
echo "=== All BusyBox binaries tested ==="
