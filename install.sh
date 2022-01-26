#!/bin/bash
echo "Installation du script OGST Batocera en cours"
# full write enable
mount -o remount,rw /
mount -o remount,rw /boot
# download package
wget -q -nv -O /userdata/system/ogstbatocera.zip https://batocera.org/special/OGST/ogstbatocera.zip
# unzip package
unzip -o -q /userdata/system/ogstbatocera.zip -d /userdata/system
# move OGST folder to the /userdata/ path
mv  /userdata/system/OGST  /userdata/OGST
# delete package
rm -f /userdata/system/ogstbatocera.zip
# make ffmpeg executable
chmod +x /usr/bin/ffmpeg
# make custom script executable
chmod +x /userdata/system/custom.sh
# restore emulatorlauncher.py backup if exists
if [ -f /usr/lib/python2.7/site-packages/configgen/emulatorlauncher.py.bak ]; then
    cp -f /usr/lib/python2.7/site-packages/configgen/emulatorlauncher.py.bak /usr/lib/python2.7/site-packages/configgen/emulatorlauncher.py
    rm -f /usr/lib/python2.7/site-packages/configgen/emulatorlauncher.py.bak
fi
# patch emulatorlauncher.py making a bakup
search="\ \ \ \ \ \ \ \ # run the emulator"
insert=$'\ \ \ \ \ \ \ \ subprocess.Popen(["test -e \'/userdata/system/custom.sh\' && /userdata/system/custom.sh %s"%system.name], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) # load tft logo'
sed -i.bak -e "/$search/i $insert" /usr/lib/python2.7/site-packages/configgen/emulatorlauncher.py
# recompil emulatorlauncher.py
python -c "import py_compile; py_compile.compile('/usr/lib/python2.7/site-packages/configgen/emulatorlauncher.py')"
# save overlay
batocera-save-overlay
# delete install script
rm -f install-ogst-batocera.sh
echo "Installation ok (si pas d'erreur(s) ci dessus).. Redemarrage en cours...."
sleep 3
reboot
