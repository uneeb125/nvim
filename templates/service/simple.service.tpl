;; systemd
# /etc/systemd/system/{{_file_name_}}
# Created by {{_author_}} on {{_date_}}

[Unit]
Description={{_file_name_}} - Simple Service
After=network.target

[Service]
# User to run as (ensure user has permissions for the script)
User=root

# Absolute path to the command
ExecStart={{_cursor_}}

# Auto-restart if it crashes
Restart=on-failure

[Install]
WantedBy=multi-user.target
