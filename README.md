#Google NIK Collection from GIMP

**THIS IS A WORK IN PROGRESS**

This guide assumes you have both Ubuntu 14.04 and GIMP-2.8. I am not responsible
if this guides messes with your system.


##NIK Filters working under PlayOnLinux

Right now, I could only use the following filters:

* Analog Efex Pro 2
    * Load time really slow (takes me 4 minutes)

* Color Efex Pro 4
    * Load time slow (takes me 2 minutes)

* Dfine2
    * Works perfectly, really fast.

* SHP3RPS
    * Works perfectly, really fast.


##PlayOnLinux script
If you want to try it out, I have made a script to run in PlayOnLinux.

[PlayOnLinux Script](nikplayonlinux.sh)



##Running NIK Filters from GIMP

It's possible to run the NIK filters from GIMP, just download the [NIK-Filters.py](NIK-Filters.py)
file and place it in the plug-ins folder.

    wget https://raw.githubusercontent.com/ericoporto/NikInGimp/master/NIK-Filters.py
    chmod +x NIK-Filters.py
    mkdir ~/.gimp-2.8/plug-ins/
    mv NIK-Filters.py ~/.gimp-2.8/plug-ins/


##Known Issues

###Useless error after using some filters.

GIMP will complain with the following message after using Color Efex Pro 4 and
Analog Efex Pro 2. This is because both open a TIF file and give me back a high
quality JPEG file, but the file has JPEG extension.

    Incompatible type for "RichTIFFIPTC"; tag ignored

If you click ok, the error will go away and everything will work.


###Installer complains of not writing files

Right now, it will give [errors](errorduringinstall.txt), but it's ok. The
playonlinux script will copy missing files after. Read the script before using.
