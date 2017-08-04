dir=/usr/share/arduino/hardware/arduino
lib_dir=/home/pi/arduino/lib

rm core/*.*

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


         avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
           -I$dir/cores/arduino \
           -I$dir/variants/standard \
           -I /usr/share/arduino/libraries/SoftwareSerial \
           -o core/SoftwareSerial.o /usr/share/arduino/libraries/SoftwareSerial/SoftwareSerial.cpp



echo "Compilation des librairies supplémentaires dans $lib_dir"
ls $lib_dir/ > liste.txt
while read line; do 
     echo -e "$lib_dir/$line/$line.cpp"

    avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=22 \
    -I$dir/cores/arduino \
    -I$dir/variants/standard \
    -I /usr/share/arduino/libraries/SoftwareSerial \
    -I$lib_dir/$line \
    -o core/$line.o $lib_dir/$line/$line.cpp

done < liste.txt
rm liste.txt

echo "Création de la librairie complete"
#assemblage
avr-ar rcsv core/core.a core/*.o

