#!/bin/bash
set -euo pipefail


if [ "$EUID" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

echo "=== Setting up BusyBox HTTP server ==="


mkdir -p /var/www/html

cat > /var/www/html/index.html <<EOF
I am alive naka1314
EOF


cat > /etc/bb-httpd.conf <<EOF
H:/var/www/html
I:index.html
EOF


cat > /etc/systemd/system/bb-httpd.service <<EOF
[Unit]
Description=BusyBox HTTP Server
After=network.target

[Service]
ExecStart=/opt/task2/src/busybox-1.36.1/busybox httpd -f -p 80 -c /etc/bb-httpd.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable bb-httpd
systemctl restart bb-httpd

echo "=== BusyBox HTTP server setup complete ==="
