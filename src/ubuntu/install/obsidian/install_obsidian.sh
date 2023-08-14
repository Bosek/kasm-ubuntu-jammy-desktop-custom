#!/usr/bin/env bash
set -ex

OBSIDIAN_VERSION="1.3.7"
OBSIDIAN_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}.AppImage"

mkdir -p /opt/obsidian
cd /opt/obsidian
wget -q $OBSIDIAN_URL -O obsidian.AppImage
chmod +x obsidian.AppImage
./obsidian.AppImage --appimage-extract
rm obsidian.AppImage
chown -R 1000:1000 /opt/obsidian

cat >>/opt/obsidian/squashfs-root/launcher <<EOL
#!/usr/bin/env bash
export APPDIR=/opt/obsidian/squashfs-root/
/opt/obsidian/squashfs-root/AppRun --no-sandbox "$@"
EOL

chmod +x /opt/obsidian/squashfs-root/launcher

cat >>$HOME/Desktop/obsidian.desktop <<EOL
[Desktop Entry]
Name=Obsidian
Exec=/opt/obsidian/squashfs-root/launcher %u
Terminal=false
Type=Application
Icon=/opt/obsidian/squashfs-root/obsidian.png
StartupWMClass=obsidian
X-AppImage-Version=0.8.15
Comment=Obsidian
Categories=Office;
MimeType=text/html;x-scheme-handler/obsidian;
EOL

chmod +x $HOME/Desktop/obsidian.desktop
chown 1000:1000 $HOME/Desktop/obsidian.desktop