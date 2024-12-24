# Provides automated installation for xrDebug V3 on Linux, macOS and FreeBSD.
#!/usr/bin/env bash
set -e
cat <<'EOM'
            ____       _
 __  ___ __|  _ \  ___| |__  _   _  __ _
 \ \/ / '__| | | |/ _ \ '_ \| | | |/ _` |
  >  <| |  | |_| |  __/ |_) | |_| | (_| |
 /_/\_\_|  |____/ \___|_.__/ \__,_|\__, |
                                   |___/

EOM
ARTIFACT_BASE_URL="https://github.com/xrdebug/xrdebug/releases/latest/download/"
VERSION=$(curl -s https://api.github.com/repos/xrdebug/xrdebug/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^v//')
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
darwin) OS="macos" ;;
esac
ARCH=$(uname -m)
case "$ARCH" in
x86_64) ARCH="amd64" ;;
aarch64 | arm64) ARCH="arm64" ;;
*)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac
ARTIFACT_NAME="xrdebug-${VERSION}-${OS}-${ARCH}.tar.gz"
DOWNLOAD_URL="${ARTIFACT_BASE_URL}${ARTIFACT_NAME}"
echo "Downloading xrDebug ${VERSION} for ${OS}/${ARCH}..."
if ! curl -fL -o "${ARTIFACT_NAME}" "${DOWNLOAD_URL}"; then
    echo "Error: Failed to download ${ARTIFACT_NAME}"
    echo "URL: ${DOWNLOAD_URL}"
    exit 1
fi
tar xzf "${ARTIFACT_NAME}"
rm "${ARTIFACT_NAME}"
if [ -w "/usr/local/bin" ]; then
    mv xrdebug "/usr/local/bin/xrdebug"
    chmod +x "/usr/local/bin/xrdebug"
else
    echo "Requesting sudo access to install xrdebug to /usr/local/bin..."
    sudo mv xrdebug "/usr/local/bin/xrdebug"
    sudo chmod +x "/usr/local/bin/xrdebug"
fi
echo "xrDebug ${VERSION} has been installed successfully!"
echo "You can now run 'xrdebug' from anywhere in your terminal."
