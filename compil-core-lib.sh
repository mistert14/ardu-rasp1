
# CONFIGURATION
#dir=/usr/share/arduino/hardware/arduino
dir=/opt/arduino/hardware/arduino/avr

#dir=/opt/arduino-1.8.3/hardware/arduino/avr
#ldir=/opt/arduino-1.8.3/libraries
lib_dir=./lib
#ldir2=/usr/share/arduino/libraries
ldir2=/opt/arduino/libraries
ldir=/opt/arduino/hardware/arduino/avr/libraries

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


# COMPILATION DE SOFTWARE SERIAL
echo "Génération de Software Serial"
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir/SoftwareSerial/src \
    -o core/SoftwareSerial.o $ldir/SoftwareSerial/src/SoftwareSerial.cpp

echo "Génération de Servo"
# COMPILATION DE SERVO
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir2/Servo/src \
    -I$ldir2/Servo/src/avr \
    -o core/Servo.o $ldir2/Servo/src/avr/Servo.cpp

echo "Génération de SPI"

# COMPILATION DE  SPI
avr-gcc -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir/SPI/src \
    -o core/SPI.o $ldir/SPI/src/SPI.cpp


echo "Génération de TWI WIRE"

# COMPILATION DE  TWI WIRE
avr-gcc -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir/Wire/src \
    -I$ldir/Wire/src/utility \
    -o core/twi.o $ldir/Wire/src/utility/twi.c

echo "Génération de WIRE"

# COMPILATION DE  WIRE
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir/Wire/src \
    -I$ldir/Wire/src/utility \
    -o core/Wire.o $ldir/Wire/src/Wire.cpp


echo "Génération de FIRMATA"

# COMPILATION DE  FIRMATA
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I$ldir2/Firmata/\
    -o core/Firmata.o $ldir2/Firmata/Firmata.cpp



# COMPILATION DU REP TS
for file in ./lib2/TS/*.cpp
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C++ $filename.o à partir de $file"
         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -I$ldir/SoftwareSerial/src \
           -I$ldir/Wire/src \
           -I$ldir/Wire/src/utility \
           -I./lib2/TS \
           -o core/$filename.o $file
done

# COMPILATION DE MAKEBLOCK
for file in ./lib2/makeblock/src/*.cpp
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C++ $filename.o à partir de $file"
         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -I$ldir/SoftwareSerial/src \
           -I$ldir/Wire/src \
           -I$ldir/Wire/src/utility \
           -I./lib2/makeblock/src \
           -o core/$filename.o $file
done

# COMPILATION DE IR
for file in ./lib2/IRremote/*.cpp
do
         filename=$(basename "$file")
         extension="${filename##*.}"
         filename="${filename%.*}"
         echo "Génération C++ $filename.o à partir de $file"
         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -I$ldir/SoftwareSerial/src \
           -I$ldir/Wire/src \
           -I$ldir/Wire/src/utility \
           -I./lib2/IRremote \
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
    -I$ldir/SoftwareSerial/src \
    -I$ldir/SPI/src \
    -I$ldir/Wire/src \
    -I$ldir/Wire/src/utility \
    -o core/$line.o $lib_dir/$line/$line.cpp

done < liste.txt
rm liste.txt

# CREATION DE LA LIBRAIRIE
echo "Création de la librairie complete"
avr-ar rcsv core/core.a core/*.o

