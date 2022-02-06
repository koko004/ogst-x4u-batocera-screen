#!/bin/bash
echo "Instalación del script OGST de Batocera en curso"
# full write enable
mount -o remount,rw /
mount -o remount,rw /boot
# download package
wget -q -nv -O /userdata/system/ogstbatocera.zip https://github.com/koko004/ogst-x4u-batocera-screen/raw/main/ogstbatocera.zip
wget -q -nv -O /userdata/system/ogstbatocera.z01 https://github.com/koko004/ogst-x4u-batocera-screen/raw/main/ogstbatocera.z01
wget -q -nv -O /userdata/system/ogstbatocera.z02 https://github.com/koko004/ogst-x4u-batocera-screen/raw/main/ogstbatocera.z02
wget -q -nv -O /userdata/system/ogstbatocera.z03 https://github.com/koko004/ogst-x4u-batocera-screen/raw/main/ogstbatocera.z03
wget -q -nv -O /userdata/system/ogstbatocera.z04 https://github.com/koko004/ogst-x4u-batocera-screen/raw/main/ogstbatocera.z04
# unzip package

zip -s 0 /userdata/system/ogstbatocera.zip --out /userdata/system/unsplit-ogst.zip
unzip -o -q /userdata/system/unsplit-ogst.zip -d /userdata/system

# move OGST folder to the /userdata/ path
mv  /userdata/system/OGST  /userdata/OGST
# delete package
rm -f /userdata/system/ogstbatocera.zip
rm -f /userdata/system/ogstbatocera.z01
rm -f /userdata/system/ogstbatocera.z02
rm -f /userdata/system/ogstbatocera.z04
rm -f /userdata/system/unsplit-ogst.zip
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
echo "Instalación correcta (si no hay errores arriba). Reinicio en curso...."
sleep 3
reboot
