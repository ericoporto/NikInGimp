#!/usr/bin/env playonlinux-bash
# Date : (2016-may-4)
# Last revision : (2016-may-5)
# Wine version used : 1.7.31
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
WINE_VERSION="1.7.31"


POL_SetupWindow_Init

POL_SetupWindow_presentation "$TITLE" "Google" "https://www.google.com/nikcollection/" "ericoporto" "$PREFIX"

#create prefix
export WINEARCH="win32"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINE_VERSION"

#setup prefix
POL_Wine_InstallFonts
POL_Call POL_Install_tahoma
POL_Call POL_Install_vcrun2012
POL_Call POL_Install_corefonts

#Setting OS ver
Set_OS "winxp" "sp3"

POL_System_TmpCreate "tempgooglenik"
cd "$POL_System_TmpDir"
POL_Download "https://dl.google.com/edgedl/photos/nikcollection-full-1.2.11.exe" "284059da2b8fbec24140d59cbd3017f3"

POL_SetupWindow_wait "Installation in progress." "Google NIK Collection installation"

INSTALLER="$POL_System_TmpDir/nikcollection-full-1.2.11.exe"
POL_Wine "$INSTALLER"


POL_System_TmpDelete


POL_Shortcut "Analog Efex Pro 2.exe" "Analog Efex Pro 2"
POL_Shortcut "Color Efex Pro 4.exe" "Color Efex Pro 4"
POL_Shortcut "Dfine 2.exe" "Dfine 2"
POL_Shortcut "SHP3RPS.exe" "SHP3RPS"

POL_SetupWindow_Close

exit
