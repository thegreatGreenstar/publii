#!/bin/bash

# Publii Flatpak wrapper script
export PUBLII_RESOURCES_PATH="/app/share/publii"
export LD_LIBRARY_PATH="/app/share/publii/usr/lib:/app/share/publii:$LD_LIBRARY_PATH"

# Suppress GTK accessibility warnings
export GTK_A11Y=none
export NO_AT_BRIDGE=1

# Set up the environment
cd /app/share/publii

# Run Publii with the proper library path and disable Electron sandbox
# (Flatpak provides its own sandboxing)
exec ./Publii --no-sandbox "$@"
