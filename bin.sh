# Provides multi-arch xrDebug binary for Linux and macOS
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
MAC_BINARY_ARM64="${ARTIFACT_BASE_URL}xrdebug-macos-arm64.pkg"
MAC_BINARY_X86_64="${ARTIFACT_BASE_URL}xrdebug-macos-x86_64.pkg"
LINUX_BINARY_AARCH64="${ARTIFACT_BASE_URL}xrdebug-linux-aarch64.tar.gz"
LINUX_BINARY_X86_64="${ARTIFACT_BASE_URL}xrdebug-linux-x86_64.tar.gz"
useArchitecture=$(uname -m)
useSystem=$(uname -s)
architecture=""
system=""
case "${useArchitecture}" in
x86_64) architecture="amd64" ;;
arm64) architecture="arm64" ;;
aarch64) architecture="arm64" ;;
esac
case "${useSystem}" in
Linux*) system=Linux ;;
Darwin*) system=Mac ;;
*) ;;
esac
if [ -z "${architecture}" ]; then
    echo "[!] Unsupported architecture [${useArchitecture}]"
    exit 1
fi
if [ -z "${system}" ]; then
    echo "[!] Unsupported system [${useSystem}]"
    exit 1
fi
echo "* Requesting xrDebug for ${system} [${architecture}]"
if [ "${system}" = "Linux" ]; then
    if [ "${architecture}" = "arm64" ]; then
        DOWNLOAD_URL=${LINUX_BINARY_AARCH64}
    fi
    if [ "${architecture}" = "amd64" ]; then
        DOWNLOAD_URL=${LINUX_BINARY_X86_64}
    fi
fi
if [ "${system}" = "Mac" ]; then
    if [ "${architecture}" = "arm64" ]; then
        DOWNLOAD_URL=${MAC_BINARY_ARM64}
    fi
    if [ "${architecture}" = "amd64" ]; then
        DOWNLOAD_URL=${MAC_BINARY_X86_64}
    fi
fi
echo "* Downloading ${DOWNLOAD_URL}"
curl -sLO ${DOWNLOAD_URL}
echo "* Download complete"
if [ "${system}" = "Linux" ]; then
    echo "* Extracting xrdebug-linux-*.tar.gz"
    tar -xvf xrdebug-linux-*.tar.gz
    echo "* Setting xrdebug as executable"
    chmod +x xrdebug
    echo "* Moving xrdebug to /usr/local/bin"
    mv xrdebug /usr/local/bin/xrdebug
fi
if [ "${system}" = "Mac" ]; then
    echo "* Opening xrdebug-macos-*.pkg to continue installation"
    open xrdebug-macos-*.pkg
fi
