#!/bin/sh
RED='\e[31m'
GREEN='\e[32m'
BLUE='\e[34m'
BOLD='\e[1m'
UNDERLINE='\e[4m'
RESET='\e[0m'
ICON='->>>>>>'
clear 
echo  "${UNDERLINE}${BOLD}${GREEN}Changing directory to native lib to compile${RESET}.."
compile() {
    export ARCH=x64
    gn gen out/Linux-$ARCH --args="target_os=\"linux\" target_cpu=\"$ARCH\" is_debug=false rtc_include_tests=false rtc_use_h264=true ffmpeg_branding=\"Chrome\" is_component_build=false use_rtti=true use_custom_libcxx=false rtc_enable_protobuf=false"
    ninja -C out/Linux-x64 libwebrtc
    return $?
}
run_flutter() {
    echo "${UNDERLINE}${BOLD}${BLUE}Cleaning and Running flutter${RESET}.."
    rm -rf build/
    flutter clean && flutter pub get && flutter run -d linux -v
}

cd ../../libwebrtc_b/src/libwebrtc/ && pwd
echo "${UNDERLINE}${BOLD}${BLUE}Compiling libwebrtc${RESET}.."
if compile; then
    echo "${GREEN}${ICON}${RESET} ${UNDERLINE}${BOLD}Compilation successful${RESET}"
    echo "${UNDERLINE}${BOLD}${BLUE}Copying libwebrtc.so to flutter_webrtc${RESET}.."
    cp out/Linux-x64/libwebrtc.so ../../../flutter_webrtc/third_party/libwebrtc/lib/linux-x64/libwebrtc.so
    cd -
    run_flutter
    exit 0
else
    echo  "${RED}${ICON}${RESET} ${UNDERLINE}${BOLD}Compilation failed${RESET}"
    exit 1
fi
