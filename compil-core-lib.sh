
# CONFIGURATION
dir=/usr/share/arduino/hardware/arduino
lib_dir=/home/pi/arduino/lib

#rm core/*.*

# COMPILATION DES FICHIERS C ARDUINO
for file in $dir/cores/arduino/*.c
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C $filename.o à partir de $file"
         avr-gcc -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -o core/$filename.o $file
done

# COMPILATION DES FICHIERS C++ ARDUINO
for file in $dir/cores/arduino/*.cpp
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C++ $filename.o à partir de $file"
         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -o core/$filename.o $file
done

#exit 0;

# COMPILATION DE SOFTWARE SERIAL
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I /usr/share/arduino/libraries/SoftwareSerial \
    -o core/SoftwareSerial.o /usr/share/arduino/libraries/SoftwareSerial/SoftwareSerial.cpp

# COMPILATION DE SERVO
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I /usr/share/arduino/libraries/Servo \
    -o core/Servo.o /usr/share/arduino/libraries/Servo/Servo.cpp

# COMPILATION DE  TWI WIRE
avr-gcc -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I /usr/share/arduino/libraries/Wire \
    -I /usr/share/arduino/libraries/Wire/utility \
    -o core/twi.o /usr/share/arduino/libraries/Wire/utility/twi.c


# COMPILATION DE  WIRE
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I /usr/share/arduino/libraries/Wire \
    -I /usr/share/arduino/libraries/Wire/utility \
    -o core/Wire.o /usr/share/arduino/libraries/Wire/Wire.cpp

# COMPILATION DE  FIRMATA
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I /usr/share/arduino/libraries/Firmata\
    -o core/Firmata.o /usr/share/arduino/libraries/Firmata/Firmata.cpp


# COMPILATION DU REP TS
for file in /home/pi/arduino/lib2/TS/*.cpp
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C++ $filename.o à partir de $file"
         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -I /usr/share/arduino/libraries/SoftwareSerial \
           -I /usr/share/arduino/libraries/Wire \
           -I /usr/share/arduino/libraries/Wire/utility \
           -I/home/pi/arduino/lib2/TS \
           -o core/$filename.o $file
done




# COMPILATION DES  LIB PERSO
echo "Compilation des librairies supplémentaires dans $lib_dir"
ls $lib_dir/ > liste.txt
while read line; do 
     echo -e "$lib_dir/$line/$line.cpp"

    avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$lib_dir/$line \
    -I /usr/share/arduino/libraries/SoftwareSerial \
    -o core/$line.o $lib_dir/$line/$line.cpp

done < liste.txt
rm liste.txt

# CREATION DE LA LIBRAIRIE
echo "Création de la librairie complete"
avr-ar rcsv core/core.a core/*.o

