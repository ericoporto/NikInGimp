#Google NIK Collection from GIMP
This guide assumes you have both Ubuntu 14.04 and GIMP-2.8. I am not responsible
if this guides messes with your system.

##Install Wine

    sudo apt-get install wine

##Download and Install Google NIK Collection

    cd ~/
    wget https://dl.google.com/edgedl/photos/nikcollection-full-1.2.11.exe
    wine nikcollection-full-1.2.11.exe

Follow what's on the screen - basically just click next and wait for it to
finish. In case of errors, choose **ignore**.

##Download this script and place in plug-ins

    wget https://raw.githubusercontent.com/ericoporto/NikInGimp/master/ShellOut.py
    chmod +x ShellOut.py
    mkdir ~/.gimp-2.8/plug-ins/
    mv ShellOut.py ~/.gimp-2.8/plug-ins/
