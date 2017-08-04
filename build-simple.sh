dir=/usr/share/arduino/hardware/arduino
projet=sketch
serie=/dev/ttyACM0
baud=115200

projet=$1

rm ./hex/$projet.hex

cp ./ino/$projet.ino $projet.cpp
sed -i "1i\#include \"Arduino.h\"\n" $projet.cpp

avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
-I $dir/cores/arduino \
-I $dir/variants/standard \
-o $projet.o $projet.cpp


echo "Edition des liens"
#linkage
avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p -o $projet.elf $projet.o core/core.a -L core -lm

echo "Génération du fichier HEX"
avr-objcopy -O ihex -R .eeprom $projet.elf ./hex/$projet.hex

echo "Upload du fichier - Arduino branché en $serie"
avrdude -v -p m328p -P $serie -b $baud -c arduino -U flash:w:./hex/$projet.hex

rm $projet.o
rm $projet.cpp
rm $projet.elf

echo  "Executer ./serial.sh pour lire le port série" 

