dir=/usr/share/arduino/hardware/arduino
projet=StandardFirmata
serie=/dev/ttyACM0
baud=115200
lib_dir=/home/pi/arduino/lib


cp ./ino/$projet.ino $projet.cpp
sed -i "1i\#include \"Arduino.h\"\n" $projet.cpp

#Bien ajouter les -I des lib
ls $lib_dir/ > liste.txt

tmp=""

while read line; do 
    echo -e "$line"; 
    tmp=$tmp" -I $lib_dir/$line" 
done < liste.txt
#echo $tmp


#exit 0;


    avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -o $projet.o $projet.cpp \
    -I $dir/cores/arduino \
    -I $dir/variants/standard \
    $tmp \
    -I /usr/share/arduino/libraries/SoftwareSerial \
    -I /usr/share/arduino/libraries/Wire \
    -I /usr/share/arduino/libraries/Wire/utility \
    -I /usr/share/arduino/libraries/Firmata \
    -I /usr/share/arduino/libraries/Firmata/utility \
    -I /usr/share/arduino/libraries/Servo


rm liste.txt


echo "Edition des liens"
#linkage
avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p \
    -I /usr/share/arduino/libraries/SoftwareSerial \
    -I /usr/share/arduino/libraries/Servo \
    -I /usr/share/arduino/libraries/Firmata \
    -I /usr/share/arduino/libraries/Firmata/utility \
    -I /usr/share/arduino/libraries/Wire \
    -I /usr/share/arduino/libraries/Wire/utility \
    -o $projet.elf $projet.o core/core.a -L core -lm

echo "Génération du fichier HEX"
avr-objcopy -O ihex -R .eeprom $projet.elf ./hex/$projet.hex

echo "Upload du fichier - Arduino branché en $serie"
avrdude -v -p m328p -P $serie -b $baud -c arduino -U flash:w:./hex/$projet.hex

rm $projet.o
rm $projet.elf
rm $projet.cpp

#echo screen $serie $baud

