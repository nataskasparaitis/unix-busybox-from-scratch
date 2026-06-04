#!/bin/bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

BB="/opt/task2/src/busybox-1.36.1/busybox"

if [ ! -x "$BB" ]; then
    echo "BusyBox binary not found"
    exit 1
fi

echo "Deploying BusyBox applets to /bin/"

for cmd in $($BB --list); do
    target="/bin/bb-$cmd"

    cat > "$target" <<EOF
#!/bin/sh
exec $BB $cmd "\$@"
EOF

    chmod +x "$target"
done

echo "Deployment complete"
