#!/bin/bash

# Colours Variables
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

# Destination directory
#ROOT_UID=0
DEST_DIR="/usr/share/fonts/Minecraft/TrueType/MinecraftUI/"
WINE_FONT_DIR="$HOME/.wine/drive_c/windows/Fonts/"

#if [ "$UID" -eq "$ROOT_UID" ]; then
#  DEST_DIR="/usr/local/share/fonts/Minecraft/TrueType/MinecraftUI/
#else
#  DEST_DIR="$HOME/.local/share/fonts/Minecraft/TrueType/MinecraftUI/"
#fi

# Check Internet Conection
function cekkoneksi(){
    echo -e "$BLUE [ * ] Checking for internet connection"
    sleep 1
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "$RED [ X ]$BLUE Internet Connection ➜$RED OFFLINE!\n";
        echo -e "$RED Sorry, you really need an internet connection...."
        exit 0
    else
        echo -e "$GREEN [ ✔ ]$BLUE Internet Connection ➜$GREEN CONNECTED!\n";
        sleep 1
    fi
}

function cekwget(){
    echo -e "$BLUE [ * ] Checking for Wget"
    sleep 1
    which wget > /dev/null 2>&1
    if [ "$?" -eq "0" ]; then
    echo -e "$GREEN [ ✔ ]$BLUE Wget ➜$GREEN INSTALLED\n"
        sleep 1
    else
        echo -e "$RED [ X ]$BLUE Wget ➜$RED NOT INSTALLED\n"
        continueWget
    fi
}

function cekfont(){
    echo -e "$BLUE [ * ] Checking for Minecraft-UI Font"
    sleep 1
    fc-list | grep -i "Minecraft-UI" >/dev/null 2>&1
    if [ "$?" -eq "0" ]; then
    echo -e "$GREEN [ ✔ ]$BLUE Minecraft-UI Font ➜$GREEN INSTALLED\n"
        sleep 1
    else
        echo -e "$RED [ X ]$BLUE Minecraft-UI Font ➜$RED NOT INSTALLED\n"
        continueFont
    fi
}

function continueFont(){
    echo -e "$LGREEN Do you want to install Minecraft-UI Font? (y)es, (n)o :"
    read  -p ' ' INPUT
    case $INPUT in
    [Yy]* ) fontinstall;;
    [Nn]* ) end;;
    * ) echo -e "$RED\n Sorry, try again."; continueFont;;
  esac
}

function fontinstall(){
    sudo mkdir -p "$DEST_DIR"
    if [ -d font ]; then
        cp font/MinecraftTen.ttf "$DEST_DIR"/MinecraftTen.ttf > /dev/null 2>&1 # MinecraftTen        
        cp font/MinecraftTenE.ttf "$DEST_DIR"/MinecraftTenE.ttf > /dev/null 2>&1 # MinecraftTenE
        
        if [ -d $WINE_FONT_DIR ]; then        
            cp font/MinecraftTen.ttf "$WINE_FONT_DIR"/MinecraftTen.ttf > /dev/null 2>&1 # MinecraftTen
            cp font/MinecraftTenE.ttf "$WINE_FONT_DIR"/MinecraftTenE.ttf > /dev/null 2>&1 # MinecraftTenE
        
            echo -e "$GREEN\n Font installed to WINE $LBLUE'$WINE_FONT_DIR'"
        fi

    else
        # Download font from github static link code
        wget -q https://github.com/Stradios/Minecraft-fonts/raw/main/font/MinecraftTen.ttf?raw=true -O "$DEST_DIR"/MinecraftTen.ttf > /dev/null 2>&1 # MinecraftTen
        wget -q https://github.com/Stradios/Minecraft-fonts/raw/main/font/MinecraftTenE.ttf?raw=true -O "$DEST_DIR"/MinecraftEvenings.ttf > /dev/null 2>&1 # MinecraftEvenings

    fi

    fc-cache -f "$DEST_DIR"
    echo -e "$GREEN\n Font installed on $LBLUE'$DEST_DIR'"
}

function wgetinstall(){   
    sleep 1
    sudo apt update > /dev/null 2>&1
    sudo apt install -y wget > /dev/null 2>&1
}

function end(){
    echo -e "$LPURPLE\n Bye..... ;)"
    exit 0
}

continueWget() {
  echo -e "$LGREEN Do you want to install Wget? (y)es, (n)o :"
  read  -p ' ' INPUT
  case $INPUT in
    [Yy]* ) wgetinstall;;
    [Nn]* ) end;;
    * ) echo -e "$RED\n Sorry, try again."; continueWget;;
  esac
}

function banner(){
    echo -e "$LYELLOW" ""
    echo -e "Minecraft Font "

}

main(){
    clear
    banner
    cekkoneksi
    cekwget
    cekfont
}

main
