# Unofficial Publii Flatpak
Unofficial, work in progress, rudimentary, experimental & probably unstable Flatpak build for Publii - in other words, use it if you know you can handle errors.



## Prerequisites
Before building, you need to install Flatpak, flatpak-builder, and ImageMagick:
```bash
sudo apt update
sudo apt install flatpak flatpak-builder imagemagick
```
Add the Flathub repository if not already added:
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Dynamic Version Handling
The `build-flatpak.sh` script dynamically fetches the latest Publii AppImage from the official website. It does not automatically update the `io.publii.Publii.metainfo.xml` (yet).

## Permissions
The Flatpak has the following permissions:
- Network access (for publishing sites)
- Documents directory access (for storing sites and projects)
- Desktop integration (notifications, file chooser)
- Hardware acceleration (OpenGL/Vulkan, can't hurt because of Electron probably?)
- Session bus access (for... things?)

### Known Issues
- `Failed to connect to the bus: Failed to connect to socket /run/dbus/system_bus_socket` - found in console, not sure if this is normal in sandboxed environments
- `Failed to load module "canberra-gtk-module"` - *not researched yet*
