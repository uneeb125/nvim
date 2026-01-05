;; desktop
[Desktop Entry]
# Created by {{_author_}} on {{_date_}}
Type=Application
Name={{_file_name_}}
Exec=/path/to/executable %F

# --- OPTIONAL BUT RECOMMENDED ---
GenericName=Generic Name
Comment=A brief description of what this app does
Icon=application-icon-name
Terminal=false
Categories=Utility;

# --- ADVANCED OPTIONS ---
Keywords=keyword1;keyword2;
MimeType=image/jpeg;text/plain;
StartupNotify=true
StartupWMClass=app-window-class

# --- ACTIONS (Right-click menu options) ---
Actions=Gallery;Edit;

[Desktop Action Gallery]
Name=Open in Gallery Mode
Exec=/path/to/executable --gallery %F

[Desktop Action Edit]
Name=Open in Editor
Exec=/path/to/executable --edit %F
{{_cursor_}}
