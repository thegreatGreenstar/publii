#!/bin/bash

# Exit on error
set -e

echo "Checking prerequisites..."
# Check if required tools are available
if ! flatpak list | grep -q "org.freedesktop.Platform.*23.08"; then
    echo "Required Freedesktop runtime is not installed. Please install it manually with the following command:"
    echo "flatpak install --user flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08 -y"
    exit 1
fi
for cmd in flatpak-builder convert curl; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed. Please install it first."
        exit 1
    fi
done

# Get the latest Publii release URL and version #TODO: wacky web scraping, maybe use github api to get release number
echo "Fetching the latest Publii release..."
LATEST_RELEASE_URL=$(curl -s https://getpublii.com/download/ | grep -oE 'https://cdn.getpublii.com/Publii-[0-9]+\.[0-9]+\.[0-9]+\.AppImage' | head -n 1)
LATEST_VERSION=$(echo "$LATEST_RELEASE_URL" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
if [ -z "$LATEST_RELEASE_URL" ]; then
    echo "Error: Unable to fetch the latest Publii release URL. Please verify the website availability."
    exit 1
fi
if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Unable to extract the Publii version from the URL."
    exit 1
fi

# Download the latest Publii AppImage
echo "Latest Publii version: $LATEST_VERSION"
echo "Downloading Publii AppImage..."
curl -L "$LATEST_RELEASE_URL" -o "Publii-$LATEST_VERSION.AppImage"

# Ensure the AppImage is executable
chmod +x "Publii-$LATEST_VERSION.AppImage"
# Extract the AppImage
echo "Extracting Publii AppImage..."
./"Publii-$LATEST_VERSION.AppImage" --appimage-extract

# Resize the icon to comply with Flatpak requirements (max 512x512)
ICON_PATH="squashfs-root/Publii.png"
if [ -f "$ICON_PATH" ]; then
    convert "$ICON_PATH" -resize 512x512 "$ICON_PATH"
    echo "Icon resized successfully."
else
    echo "Warning: Icon file not found at $ICON_PATH"
fi

# Build the Flatpak
echo "Begin build..."
flatpak-builder --user --install --force-clean build-dir io.publii.Publii.yml
echo "Build finished:  flatpak run io.publii.Publii"

# Create bundle
echo "Creating .flatpak bundle file... (this may take a minute or two)"
flatpak build-bundle ~/.local/share/flatpak/repo ./publii.flatpak io.publii.Publii
echo "Bundle created: publii.flatpak"

# Optional, clean up files
rm -rf "Publii-$LATEST_VERSION.AppImage" squashfs-root build-dir .flatpak-builder
#echo "Temporary files cleaned up."
