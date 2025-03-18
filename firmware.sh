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
    Awa*) device="dedede" ;;
    Beadrix*) device="dedede" ;;
    Beetley*) device="dedede" ;;
    Blipper*) device="dedede" ;;
    Bookem*) device="dedede" ;;
    Boten*) device="dedede" ;;
    Boxy*) device="dedede" ;;
    Buggzy*) device="dedede" ;;
    Cret*) device="dedede" ;;
    Dexi*) device="dedede" ;;
    Dita*) device="dedede" ;;
    Draw*) device="dedede" ;;
    Gal*) device="dedede" ;;
    Kracko*) device="dedede" ;;
    Lan*) device="dedede" ;;
    Madoo*) device="dedede" ;;
    Mag*) device="dedede" ;;
    Metaknight*) device="dedede" ;;
    Palutena*) device="dedede" ;;
    Pasara*) device="dedede" ;;
    Peezer*) device="dedede" ;;
    Pirette*) device="dedede" ;;
    Pirika*) device="dedede" ;;
    Sasuk*) device="dedede" ;;
    Storo*) device="dedede" ;;
    Tarzana*) device="dedede" ;;
    # Corsola
    Chinchou*) device="corsola" ;;
    Keldeo*) device="corsola" ;;
    Kyogre*) device="corsola" ;;
    Magneton*) device="corsola" ;;
    Rusty*) device="corsola" ;;
    Skitty*) device="corsola" ;;
    Squirtle*) device="corsola" ;;
    Steelix*) device="corsola" ;;
    Tenta*) device="corsola" ;;
    Veluza*) device="corsola" ;;
    Voltorb*) device="corsola" ;;
    # Nissa
    Anraggar*) device="nissa" ;;
    Craask*) device="nissa" ;;
    Domi*) device="nissa" ;;
    Gana*) device="nissa" ;;
    Glassway*) device="nissa" ;;
    Gothrax*) device="nissa" ;;
    Hideo*) device="nissa" ;;
    Joxer*) device="nissa" ;;
    Pujjo*) device="nissa" ;;
    Quandiso*) device="nissa" ;;
    Riven*) device="nissa" ;;
    Rudriks*) device="nissa" ;;
    Rynax*) device="nissa" ;;
    Sundance*) device="nissa" ;;
    Teliks*) device="nissa" ;;
    Uldren*) device="nissa" ;;
    Xivu*) device="nissa" ;;
    Yahiko*) device="nissa" ;;
    Yavi*) device="nissa" ;;
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


