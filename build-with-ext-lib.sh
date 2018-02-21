dir=/opt/arduino/hardware/arduino/avr
lib_dir=./lib
ldir2=/opt/arduino/libraries
ldir=/opt/arduino/hardware/arduino/avr/libraries

projet=Serre
serie=/dev/ttyACM0
baud=115200


cp ./ino/$projet.ino $projet.cpp
sed -i "1i\#include \"Arduino.h\"\n" $projet.cpp

#Bien ajouter les -I des lib
ls $lib_dir/ > liste.txt

tmp=""

while read line; do 
    echo -e "$line"; 
    tmp=$tmp" -I $lib_dir/$line" 
done < liste.txt



    avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -o $projet.o $projet.cpp \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir/SoftwareSerial/src \
    -I$ldir/Wire/src \
    -I$ldir/Wire/src/utility \
    -I./lib2/TS \
    $tmp \
    -I$ldir/Firmata/src \
    -I$ldir/Firmata/src/utility \
    -I./lib2/TS \
    -I./lib2/makeblock/src \
    -I./lib2/IRremote \
    -I$ldir/Servo



rm liste.txt


echo "Edition des liens"
#linkage
avr-gcc -w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p -o $projet.elf $projet.o core/core.a -L core -lm

echo "Génération du fichier HEX"
avr-objcopy -O ihex -R .eeprom $projet.elf ./hex/$projet.hex

echo "Upload du fichier - Arduino branché en $serie"
avrdude -v -p m328p -P $serie -b $baud -c arduino -U flash:w:./hex/$projet.hex

#rm $projet.o
#rm $projet.elf
#rm $projet.cpp

echo screen $serie $baud

