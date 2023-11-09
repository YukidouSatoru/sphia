#!/bin/bash
echo "Installing flutter_distributor"
dart pub global activate flutter_distributor
export PATH="$PATH":"$HOME/.pub-cache/bin"

repoPath=$(git rev-parse --show-toplevel)

echo "Updating sphiaLastCommitHash"
commitHash=$(git rev-parse HEAD)
aboutPageDart="lib/view/page/about.dart"
if [[ "$(uname)" == "Linux" ]]; then
    sed -i "s/const sphiaLastCommitHash = 'SELF_BUILD';/const sphiaLastCommitHash = '$commitHash';/" "$aboutPageDart"
else
    sed -i '' "s/const sphiaLastCommitHash = 'SELF_BUILD';/const sphiaLastCommitHash = '$commitHash';/" "$aboutPageDart"
fi

if [[ "$(uname)" == "Linux" ]]; then
    echo "Installing dependencies"
    sudo apt-get update
    sudo apt-get install -y clang ninja-build libayatana-appindicator3-dev libgtk-3-0 libblkid1 liblzma5 locate libfuse2
    wget -O appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool
    sudo mv appimagetool /usr/local/bin

    echo "Building Sphia"
    flutter pub get
    flutter config --enable-linux-desktop
    flutter_distributor release --name prod --jobs release-linux-appimage
    appimage=$(find dist -type f -name 'sphia-linux.AppImage' -print -quit)
    mv $appimage dist/sphia-linux-amd64.AppImage
else
    echo "Installing dependencies"
    sudo -H pip install setuptools
    npm install -g appdmg

    echo "Building Sphia"
    flutter pub get
    flutter config --enable-macos-desktop
    flutter_distributor release --name prod --jobs release-macos-dmg
    dmg=$(find dist -type f -name 'sphia-macos.dmg' -print -quit)
    mv $dmg dist/sphia-macos-universal.dmg
fi
