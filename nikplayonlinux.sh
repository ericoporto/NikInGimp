#!/bin/bash
# Date : (2016-may-4)
# Last revision : (2016-may-5)
# Wine version used : 1.8.2
# Distribution used to test : Ubuntu 14.04
# Author : ericoporto

# WORK IN PROGRESS
# Script for installing Google NIK Collection from PlayOnLinux
# Supported filters are:
#   - Analog Efex Pro 2
#   - Color Efex Pro 4
#   - Dfine2
#   - SHP3RPS
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="Google NIK Collection" # Should be present in all your scripts
PREFIX="GoogleNikCollection"
WINE_VERSION="1.8.2"
NAMEOFINSTALLATION="$TITLE installation"

POL_SetupWindow_Init
POL_Debug_Init

POL_SetupWindow_presentation "$TITLE" "Google" "https://www.google.com/nikcollection/" "ericoporto" "$PREFIX"

#create prefix
POL_Wine_SelectPrefix "$PREFIX"
POL_System_SetArch "x86"
POL_Wine_PrefixCreate "$WINE_VERSION"

POL_System_TmpCreate "tempgooglenik"
cd "$POL_System_TmpDir"

#Setting OS ver
Set_OS "winxp" "sp3"

#setup prefix
POL_Wine_InstallFonts
POL_Call POL_Install_corefonts
POL_Call POL_Install_vcrun2012

#Correct permissions
#google_path="${WINEPREFIX}/drive_c/users/${USER}/Local Settings/Application Data/Google"
GOOGLE_PATH="${WINEPREFIX}/drive_c/users/Public/Local Settings/Application Data/Google"
mkdir -p "$GOOGLE_PATH"
chmod -R 777 "$GOOGLE_PATH"

GOOGLE_PATH="${WINEPREFIX}/drive_c/users/Public/Application Data/Google"
mkdir -p "$GOOGLE_PATH"
chmod -R 777 "$GOOGLE_PATH"


POL_SetupWindow_InstallMethod "LOCAL,DOWNLOAD"

if [ "$INSTALL_METHOD" = "LOCAL" ]
then
    POL_SetupWindow_browse "Please select the installation file to run." "$NAMEOFINSTALLATION"
    POL_SetupWindow_wait "Installation in progress." "$NAMEOFINSTALLATION"
    INSTALLER="$APP_ANSWER"
    cp $INSTALLER "$POL_System_TmpDir/"
elif [ "$INSTALL_METHOD" = "DOWNLOAD" ]
then
    cd "$POL_System_TmpDir"
    POL_Download "https://dl.google.com/edgedl/photos/nikcollection-full-1.2.11.exe" "284059da2b8fbec24140d59cbd3017f3"
    POL_SetupWindow_wait "Installation in progress." "$NAMEOFINSTALLATION"
    INSTALLER="$POL_System_TmpDir/nikcollection-full-1.2.11.exe"
fi

INSTALLER_FNAME=$(basename "$INSTALLER")
INSTALLER_FNAMEX="${INSTALLER_FNAME%.exe}"

POL_SetupWindow_message "Select 'ignore' for any errors that appear." "WARNING"


POL_Wine_WaitBefore "$TITLE" # Display generic wait message that doesn't block the script from continuing
POL_Wine start /unix "$INSTALLER" # start /unix is not usually recommended but neccessary in this case
POL_Wine_WaitExit "$TITLE"

#BUG: GoogleUpdate.exe OPENS IN BACKGROUND AND DOESN'T CLOSE
#HAVE TO MANUALLY KILL GoogleUpdate.exe.
#If it is stuck here, copy and paste the kill commands on your terminal.
kill `ps -x | grep services.exe | awk '{print $1;}' | head -n1`
kill `ps -x | grep GoogleUpdate.exe | awk '{print $1;}' | head -n1`
kill `ps -x | grep GoogleUpdate.exe | awk '{print $1;}' | head -n1`

#I've tried the command below but it DOESN'T WORK
# so I am going to kill everyone... In this wine.
POL_Wine wineboot -k # Kill all processes


#WORK IN PROGRESS HERE
#BUG: Files are not copyied by the installer
#Need to manually extract from the exe and copy.
#See errorduringinstall.txt
cd "$POL_System_TmpDir"
mkdir missingfiles
file-roller --extract-here ${INSTALLER_FNAME}
cd "${POL_System_TmpDir}/${INSTALLER_FNAMEX}"
find  . -mindepth 2 -iname Google -exec cp -rt "${POL_System_TmpDir}/missingfiles" {} +
cd "${POL_System_TmpDir}/missingfiles"
cp -R Google "${WINEPREFIX}/drive_c/users/Public/Local Settings/Application Data/"
cp -R Google "${WINEPREFIX}/drive_c/users/Public/Application Data/"


POL_System_TmpDelete

POL_SetupWindow_message "Drag and drop an image file to the icons on your desktop and wait" "How to use"

POL_Shortcut "Analog Efex Pro 2.exe" "Analog Efex Pro 2"
POL_Shortcut "Color Efex Pro 4.exe" "Color Efex Pro 4"
#Dfine2 exe has no space!
POL_Shortcut "Dfine2.exe" "Dfine 2"
POL_Shortcut "SHP3RPS.exe" "SHP3RPS"

POL_SetupWindow_Close

exit
