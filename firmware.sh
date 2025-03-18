#!/bin/bash

# This script downloads a recovery key file and applies it to the firmware using futility.  This script is ONLY intended for use on Dedede, Nissa or Corsola. Use at your own risk. I might add more keyrolled devices in the near future
# This script requires to be ran as chronos, not root. Failure to do so may result in the recovery key not being applied correctly, or the device not being able to access the recovery key file.

if grep -q "Chrom" /etc/lsb-release ; then
    DOWNLOADS_DIR="/home/chronos/user/MyFiles/Downloads"
else
    DOWNLOADS_DIR="$HOME/Downloads"
fi


device=$(dmidecode -s system-product-name | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g' | awk 'NR==1{print $1}')
device=${device^^}
device=$(echo ${device} | awk '{ print tolower($0) }')
RECOVERY_KEY_NISSA="https://raw.githubusercontent.com/Cruzy22k/NissaFW2/main/nissa_recovery_v1.vbpubk"
RECOVERY_KEY_NISSA_FILE="nissa_recovery_v1.vbpubk"
RECOVERY_KEY_DEDEDE="https://raw.githubusercontent.com/Cruzy22k/NissaFW2/main/dedede_recovery_v1.vbpubk"
RECOVERY_KEY_DEDEDE_FILE="dedede_recovery_v1.vbpubk"
RECOVERY_KEY_CORSOLA="https://raw.githubusercontent.com/Cruzy22k/NissaFW2/main/corsola_recovery_v1.vbpubk"
RECOVERY_KEY_CORSOLA_FILE="corsola_recovery_v1.vbpubk"

echo -e "\e[32m<Firmware2>  Copyleft (C) 2024  Cruzy22k\e[0m"
echo -e "\e[32mThis program comes with ABSOLUTELY NO WARRANTY.\e[0m"
echo -e "\e[32mThis is free software, and you are welcome to redistribute it under certain conditions.\e[0m"
echo


case "${device}" in
    # Dedede
    awa*) device="dedede" ;;
    beadrix*) device="dedede" ;;
    beetley*) device="dedede" ;;
    blipper*) device="dedede" ;;
    bookem*) device="dedede" ;;
    boten*) device="dedede" ;;
    boxy*) device="dedede" ;;
    buggzy*) device="dedede" ;;
    cret*) device="dedede" ;;
    dexi*) device="dedede" ;;
    dita*) device="dedede" ;;
    draw*) device="dedede" ;;
    gal*) device="dedede" ;;
    kracko*) device="dedede" ;;
    lan*) device="dedede" ;;
    madoo*) device="dedede" ;;
    mag*) device="dedede" ;;
    metaknight*) device="dedede" ;;
    palutena*) device="dedede" ;;
    pasara*) device="dedede" ;;
    peezer*) device="dedede" ;;
    pirette*) device="dedede" ;;
    pirika*) device="dedede" ;;
    sasuk*) device="dedede" ;;
    storo*) device="dedede" ;;
    tarzana*) device="dedede" ;;
    # Corsola
    chinchou*) device="corsola" ;;
    keldeo*) device="corsola" ;;
    kyogre*) device="corsola" ;;
    magneton*) device="corsola" ;;
    rusty*) device="corsola" ;;
    skitty*) device="corsola" ;;
    squirtle*) device="corsola" ;;
    steelix*) device="corsola" ;;
    tenta*) device="corsola" ;;
    veluza*) device="corsola" ;;
    voltorb*) device="corsola" ;;
    # Nissa
    anraggar*) device="nissa" ;;
    craask*) device="nissa" ;;
    domi*) device="nissa" ;;
    gana*) device="nissa" ;;
    glassway*) device="nissa" ;;
    gothrax*) device="nissa" ;;
    hideo*) device="nissa" ;;
    joxer*) device="nissa" ;;
    pujjo*) device="nissa" ;;
    quandiso*) device="nissa" ;;
    riven*) device="nissa" ;;
    rudriks*) device="nissa" ;;
    rynax*) device="nissa" ;;
    sundance*) device="nissa" ;;
    teliks*) device="nissa" ;;
    uldren*) device="nissa" ;;
    xivu*) device="nissa" ;;
    yahiko*) device="nissa" ;;
    yavi*) device="nissa" ;;
    # Other, non corsola/dedede/nissa board
    *) device="unknown" ;;
esac

case "${device}" in
    corsola) RECOVERY_KEY_URL="$RECOVERY_KEY_CORSOLA" ; RECOVERY_KEY_FILE="$RECOVERY_KEY_CORSOLA_FILE" ;;
    dedede) RECOVERY_KEY_URL="$RECOVERY_KEY_DEDEDE" ; RECOVERY_KEY_FILE="$RECOVERY_KEY_DEDEDE_FILE" ;;
    nissa) RECOVERY_KEY_URL="$RECOVERY_KEY_NISSA" ; RECOVERY_KEY_FILE="$RECOVERY_KEY_NISSA_FILE" ;;
    unknown) echo "Your device is not one of the following: corsola, dedede, nissa. Failing." ; exit 1
esac

# Debug output:
echo "DEBUG: Selected URL: $RECOVERY_KEY_URL"
echo "DEBUG: Selected file name: $RECOVERY_KEY_FILE"

mkdir -p "$DOWNLOADS_DIR"



echo "Downloading the recovery key file..."
cd "$DOWNLOADS_DIR" || exit 1
curl -L -o "$RECOVERY_KEY_FILE" "$RECOVERY_KEY_URL"

if [ ! -f "$RECOVERY_KEY_FILE" ]; then
    echo "Failed to download the recovery key file."
    exit 1
fi

echo "Downloaded the recovery key file to $DOWNLOADS_DIR/$RECOVERY_KEY_FILE."

# Ask for confirmation before applying the recovery key
echo "WARNING: Before proceeding, ensure that Write Protect (WP) is disabled on your device."
echo "Failure to disable WP may result in the recovery key not being applied correctly."
read -p "Are you sure you want to apply the recovery key with futility? (y/n) " -n 1 -r
echo    
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting the process."
    exit 1
fi


echo "Applying the recovery key with futility..."
futility gbb -s --flash --recoverykey="$DOWNLOADS_DIR/$RECOVERY_KEY_FILE"

# Check if application was successful
if [ $? -eq 0 ]; then
    echo "Successfully applied the recovery key."
else
    echo "Failed to apply the recovery key."
    # Clear the vbpubk files from the Downloads folder only if the previous command fails
    echo "Clearing the vbpubk files from the Downloads folder..."
    rm -f "$DOWNLOADS_DIR"/*.vbpubk
    sleep 5

    exit 1
fi

echo "Process completed successfully, reboot and try to boot a shim" 
echo " "
echo "Made by cruzy22k" 
echo ":)"
echo " A reboot is required for the changes to take effect."

echo "Clearing the vbpubk files from the Downloads folder..."
rm -f "$DOWNLOADS_DIR"/*.vbpubk


sleep 5

echo "the vbpubk files have been removed from the Downloads folder."

echo " "



read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi

echo   
sleep 10


echo "Please reboot your system manually to see changes take effect"


