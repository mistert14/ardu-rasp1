dir=/opt/arduino-1.8.3/hardware/arduino/avr/cores/arduino
projet=sketch
serie=/dev/ttyACM1
baud=115200

for file in $dir/*.c
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C $filename.o à partir de $file"
         avr-gcc -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I/opt/arduino-1.8.3/hardware/arduino/avr/cores/arduino \
           -I/opt/arduino-1.8.3/hardware/arduino/avr/variants/standard \
           -o core/$filename.o $file
done

for file in $dir/*.cpp
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C++ $filename.o à partir de $file"
         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I/opt/arduino-1.8.3/hardware/arduino/avr/cores/arduino \
           -I/opt/arduino-1.8.3/hardware/arduino/avr/variants/standard \
           -o core/$filename.o $file

done

echo "Création de la librairie"
#assemblage
avr-ar rcsv core/core.a core/*.o

avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
-I/opt/arduino-1.8.3/hardware/arduino/avr/cores/arduino \
-I/opt/arduino-1.8.3/hardware/arduino/avr/variants/standard \
-o $projet.o $projet.cpp


echo "Edition des liens"
#linkage
avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p -o $projet.elf $projet.o core/core.a -L core -lm

echo "Génération du fichier HEX"
avr-objcopy -O ihex -R .eeprom $projet.elf $projet.hex

echo "Upload du fichier - Arduino branché en $serie"
avrdude -v -p m328p -P $serie -b $baud -c arduino -U flash:w:$projet.hex

