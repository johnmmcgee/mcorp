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

fons_list=("3270" "Agave" "AnonymousPro" "Arimo" "AurulentSansMono" "BigBlueTerminal" "BitstreamVeraSansMono" "CascadiaCode" "CodeNewRoman" "ComicShannsMono" "Cousine" "DaddyTimeMono" "DejaVuSansMono" "DroidSansMono" "FantasqueSansMono" "FiraCode" "FiraMono" "Gohu" "Go-Mono" "Hack" "Hasklig" "HeavyData" "Hermit" "iA-Writer" "IBMPlexMono" "InconsolataGo" "InconsolataLGC" "Inconsolata" "IosevkaTerm" "Iosevka" "JetBrainsMono" "Lekton" "LiberationMono" "Lilex" "Meslo" "Monofur" "Monoid" "Mononoki" "MPlus" "NerdFontsSymbolsOnly" "Noto" "OpenDyslexic" "Overpass" "ProFont" "ProggyClean" "RobotoMono" "ShareTechMono" "SourceCodePro" "SpaceMono" "Terminus" "Tinos" "UbuntuMono" "Ubuntu" "VictorMono")

if [ "$#" -gt 0 ]; then
    for font_name in "$@"; do
        echo "[-] Downloading ${font_name} Nerd Font [-]"
        download_and_install_font "$font_name"
    done
else
    if [ -t 0 ]; then  # Check if script has a terminal
        # Print available fonts in multi-column format
        echo "Available Fonts:"
        for i in "${!fons_list[@]}"; do 
            printf "%3d: %-20s" "$i" "${fons_list[$i]}"
            if (( ($i + 1) % 3 == 0 )); then
                echo
            fi
        done
        echo

        # Ask user to select fonts
        echo "Enter the numbers of the fonts you want to install, separated by space (e.g., 1 3 5):"
        read -a selected_indexes

        # Confirm selection
        echo "You've selected:"
        for i in "${selected_indexes[@]}"; do
            echo "$i: ${fons_list[$i]}"
        done

        echo "Proceed with installation? [y/N]"
        read proceed

        if [[ "$proceed" == "Y" || "$proceed" == "y" ]]; then
            for i in "${selected_indexes[@]}"; do
                echo "[-] Downloading ${fons_list[$i]} Nerd Font [-]"
                download_and_install_font "${fons_list[$i]}"
            done
        else
            echo "Installation aborted."
        fi
    else
        echo "No arguments provided and no terminal available for interactive selection. Aborting."
        exit 1
    fi
fi
