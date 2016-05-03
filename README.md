#Google NIK Collection from GIMP
THIS IS A WORK IN PROGRESS

This guide assumes you have both Ubuntu 14.04 and GIMP-2.8. I am not responsible
if this guides messes with your system.

##Install Wine and PlayOnLinux

    sudo apt-get install wine playonlinux

##Download and Install Google NIK Collection

    cd ~/
    wget https://dl.google.com/edgedl/photos/nikcollection-full-1.2.11.exe

    Now open PlayOnLinux from Ubuntu Dash, click **Configure**.

    Click **New**, Next, **64-bits Windows installation**, Next, **1.7.31**,
Next, type `googlenik` as the name of the VirtualDrive. It will create an entry
called googlenik. Click on it, Click **Install Components**, and select
`vcrun2012` from the list. Install it.

    Now, back to the tabbed view of the PlayOnLinux configuration, still in the
googlenik instance, click on Miscellaneous, and click **Run a .exe file in this
virtual drive**. Select the file `nikcollection-full-1.2.11.exe` you just
downloaded.

    Follow what's on the screen - basically just click next and wait for it to
finish. In case of errors, choose **ignore**.

    Now time to make the shortcuts to use the Nik Filters in standalone first,
back to the tabbed view of the PlayOnLinux configuration, still in the
googlenik instance. Click on **Make a new shortcut from this virtual drive**. In
the window that is open, if you are using a 64-bits Window Installation as I
told you to use before, select the second below of a filter and proceed. Repeat
until you have done this to each of the second NIK Filter available.

![](img/nikplayonlinux3.png)

    Time to test. Open a shell and type:

    /usr/share/playonlinux/playonlinux --run "Dfine2" EXAMPLEIMG.png



##Download this script and place in plug-ins

    wget https://raw.githubusercontent.com/ericoporto/NikInGimp/master/ShellOut.py
    chmod +x ShellOut.py
    mkdir ~/.gimp-2.8/plug-ins/
    mv ShellOut.py ~/.gimp-2.8/plug-ins/
