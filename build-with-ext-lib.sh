dir=/opt/arduino-1.8.3/hardware/arduino/avr
ldir=/opt/arduino-1.8.3/libraries
lib_dir=/home/mistert/arduino/lib
ldir2=$dir/libraries

projet=Serial
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
    -I $dir/cores/arduino \
    -I $dir/variants/standard \
    $tmp \
    -I$ldir2/SoftwareSerial/src \
    -I$ldir2/Wire/src \
    -I$ldir2/Wire/src/utility \
    -I$ldir/Firmata \
    -I$ldir/Firmata/utility \
    -I /home/mistert/arduino/lib2/TS \
    -I$ldir/Servo/src



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

