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

POL_Wine_WaitBefore "$TITLE" # Display generic wait message that doesn't block the script from continuing

#Let's check if we have 7zip, because it's packed by 7zip
[ -x "/usr/bin/7z" ] || POL_Debug_Fatal "$(eval_gettext 'The command 7z, which is required for installation, is unavailable. Please install the p7zip-full package.')"

#We will extract things in temporary dir
cd "$POL_System_TmpDir"

#The folders have names with special characters, we will rename everything
7z x -onik -y "$INSTALLER"
count_a=1
#I don't know how to guarantee this will work the same in every computer!
for i in nik/*; do
  new=$(printf "d_%02d" "$count_a") #02 pad to length of 2
  mv -- "$i" "nik/$new"
  let count_a=count_a+1
done
cd "$POL_System_TmpDir/nik"

#Let's copy Application Data
cd "$POL_System_TmpDir/nik/d_05"

cp -R Google "${WINEPREFIX}/drive_c/users/Public/Local Settings/Application Data/"
cp -R Google "${WINEPREFIX}/drive_c/users/Public/Application Data/"

#Now we need to add the proper resource to Application Data
cd "$POL_System_TmpDir/nik/d_04"

NIK_FIL_ARRAY=("Analog Efex Pro 2" "Color Efex Pro 4" "HDR Efex Pro 2" "Silver Efex Pro 2")
NIK_RES_ARRAY=("common" "comparisonStatePresets" "cursors" "filters" "lng" "plugin_common" "resolutions" "styles" "textures" "presets")
for item in "${NIK_FIL_ARRAY[@]}"; do
    for jtem in "${NIK_RES_ARRAY[@]}"; do
        mkdir -p "${WINEPREFIX}/drive_c/users/Public/Application Data/Google/${item}/resource/"
        cp -fR "${jtem}" "${WINEPREFIX}/drive_c/users/Public/Application Data/Google/${item}/resource/"
    done
done

#Let's get only 32-bit version of filters and place on the correct folder
cd "$POL_System_TmpDir/nik/d_02"

rm -rf "Analog Efex Pro 2/Analog Efex Pro 2 (64-Bit)"
rm -rf "Color Efex Pro 4/Color Efex Pro 4 (64-Bit)"
rm -rf "Dfine 2/Dfine 2 (64-Bit)"
rm -rf "HDR Efex Pro 2/HDR Efex Pro 2 (64-Bit)"
rm -rf "Sharpener Pro 3/Sharpener Pro 3 (64-Bit)"
rm -rf "Silver Efex Pro 2/Silver Efex Pro 2 (64-Bit)"
rm -rf "Viveza 2/Viveza 2 (64-Bit)"

NIK_PF="${WINEPREFIX}/drive_c/${PROGRAMFILES}/Google/Nik Collection"
mkdir -p "${NIK_PF}"
cp -R * "${NIK_PF}/"

#Let's create config files for each filter.
NIK_ARRAY=("Analog Efex Pro 2" "Dfine 2" "Color Efex Pro 4" "HDR Efex Pro 2" "Sharpener Pro 3" "Viveza 2" "Nik Collection" "Silver Efex Pro 2")
for item in "${NIK_ARRAY[@]}"; do
    NIK_F=$item
	NIK_F_NW="$(echo -e "${NIK_F}" | tr -d '[[:space:]]')"
    NIK_F_DIR="${WINEPREFIX}/drive_c/users/${USER}/Local Settings/Application Data/Google/${NIK_F}"
    mkdir -p "${NIK_F_DIR}"
    cat <<EOL >"${NIK_F_DIR}/${NIK_F_NW}.cfg"
<configuration>
	<group name="Language">
		<key name="Language" type="string" value="en"/>
	</group>
</configuration>
EOL
done

mkdir -p "${WINEPREFIX}/drive_c/users/Public/Application Data/Google/Nik Collection/"

cat <<EOF >"${WINEPREFIX}/drive_c/users/Public/Application Data/Google/Nik Collection/NikCollection.cfg"
<configuration>
	<group name="Update">
		<key name="Version" type="string" value="1.2.11"/>
	</group>
	<group name="Installer">
		<key name="LicensePath" type="string" value="C:\Program Files\Google\Nik Collection"/>
		<key name="Version" type="string" value="1.2.11"/>
		<key name="identifier" type="string" value="1415926535"/>
		<key name="edition" type="string" value="full"/>
	</group>
	<group name="Instrumentation">
		<key name="ShowInstrumentationScreen" type="bool" value="0"/>
		<key name="AllowSending" type="bool" value="0"/>
	</group>
</configuration>
EOF


POL_System_TmpDelete

POL_SetupWindow_message "Drag and drop an image file to the icons on your desktop and wait" "How to use"

POL_Shortcut "Analog Efex Pro 2.exe" "Analog Efex Pro 2"
POL_Shortcut "Color Efex Pro 4.exe" "Color Efex Pro 4"
#Dfine2 exe has no space!
POL_Shortcut "Dfine2.exe" "Dfine 2"
POL_Shortcut "SHP3RPS.exe" "SHP3RPS"

 if [ -x "/usr/bin/gimp" ]; then
     POL_SetupWindow_question "Do you want to add NIK Filters to GIMP?" "NIK and GIMP integration"
     if [$APP_ANSWER = TRUE]; then
         cd ~
         wget https://raw.githubusercontent.com/ericoporto/NikInGimp/master/NIK-Filters.py
         chmod +x NIK-Filters.py
         mkdir ~/.gimp-2.8/plug-ins/
         mv NIK-Filters.py ~/.gimp-2.8/plug-ins/
     fi
fi

POL_SetupWindow_Close

exit
