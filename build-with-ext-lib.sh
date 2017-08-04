# CONFIGURATION
dir=/usr/share/arduino/hardware/arduino
projet=test-HC05
serie=/dev/ttyACM0
baud=115200
lib_dir=/home/pi/arduino/lib

# PATCH DU FICHIER INO
cp ./ino/$projet.ino $projet.cpp
sed -i "1i\#include \"Arduino.h\"\n" $projet.cpp

# LECTURE DE LA LISTE DES LIB
ls $lib_dir/ > liste.txt

tmp=""
while read line; do 
    echo -e "$line"; 
    tmp=$tmp" -I $lib_dir/$line" 
done < liste.txt
#echo $tmp

# COMPILATION DU PROJET

    avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -o $projet.o $projet.cpp \
    -I $dir/cores/arduino \
    -I $dir/variants/standard \
    $tmp \
    -I /usr/share/arduino/libraries/SoftwareSerial

rm liste.txt

# EDITION DES LIENS

echo "Edition des liens"
#linkage
avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p -I /usr/share/arduino/libraries/SoftwareSerial -o $projet.elf $projet.o core/core.a -L core -lm


# GENERATION DU FICHIER HEX

echo "Génération du fichier HEX"
avr-objcopy -O ihex -R .eeprom $projet.elf ./hex/$projet.hex

# UPLOAD DANS L'ARDUINO

echo "Upload du fichier - Arduino branché en $serie"
avrdude -v -p m328p -P $serie -b $baud -c arduino -U flash:w:./hex/$projet.hex

# NETTOYAGE

rm $projet.o
rm $projet.elf
rm $projet.cpp

# AFFICHAGE CMD MONITEUR SERIE

#echo screen $serie $baud

