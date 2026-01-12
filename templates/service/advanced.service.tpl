;; systemd
# /etc/systemd/system/{{_file_name_}}
# Created by {{_author_}} on {{_date_}}
# Managed by Systemd

[Unit]
Description={{_file_name_}} Service
# Documentation=https://github.com/{{_author_}}/project
# Start after network is ready
After=network-online.target

[Service]
# Type options: simple (default), forking, oneshot, notify
Type=simple

# User and Group management
# WARN: It is best practice not to run as root. 
# Change to 'www-data', 'nobody', or a specific service user.
User=root
Group=root

# Main process execution
# Path must be absolute (e.g., /usr/bin/python3)
ExecStart={{_cursor_}}

# Optional: Command to run before starting
# ExecStartPre=/usr/bin/check-config

# Restart policy: no, on-success, on-failure, always
Restart=on-failure
RestartSec=5s

# ---------------- SECURITY HARDENING ----------------
# Uncomment these for production services
# ProtectSystem=full
# PrivateTmp=true
# ProtectHome=true
# NoNewPrivileges=true

# Environment variables
# EnvironmentFile=/etc/default/{{_file_name_}}
# Environment="APP_ENV=production"

[Install]
# Start automatically at boot
WantedBy=multi-user.target
