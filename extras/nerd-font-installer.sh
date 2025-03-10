#!/bin/bash

font_home="/usr/share/fonts"

download_and_install_font() {
    font_name=$1
    
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.tar.xz"

    curl -sSOL "$download_url"

    if [ "$?" -ne 0 ]; then
        echo "Error: Download failed for ${font_name}. Check if the font name is correct."
        return 1
    fi

    mkdir -p "${font_home}/${font_name}/"
    tar -xf "${font_name}.tar.xz" -C "${font_home}/${font_name}/"
    fc-cache -fv 2>&1 > /dev/null  # Suppressing output but showing errors

    if [ "$?" -ne 0 ]; then
        echo "Error: Extraction failed for ${font_name}. Skipping to the next font."
        return 1
    fi

    rm "${font_name}.tar.xz"
    echo "[-] ${font_name} Nerd Font installed successfully! [-]"
}

if [ "$#" -gt 0 ]; then
    for font_name in "$@"; do
        echo "[-] Downloading ${font_name} Nerd Font [-]"
        download_and_install_font "$font_name"
    done
else
    echo "No arguments provided. Aborting."
    exit 1
fi
