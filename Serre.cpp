#include "Arduino.h"

#include <Wire.h>
#include "rgb_lcd.h"
#include "DHT.h"

double temp;
double hum;
double sol;
double capteur;

DHT dht(4, 11);

char buffer[20];

rgb_lcd rgbLcd;

void _loop() {

}


void _delay(float seconds){
    long endTime = millis() + seconds * 1000;
    while(millis() < endTime)_loop();
}



void setup(){
    rgbLcd.begin(16,2);
    pinMode(0,INPUT);
    pinMode(2,OUTPUT);
    Serial.begin(115200);
    //Serial.println("# GESTION DE LA SERRE");
    _delay(1);

}



void loop(){

    temp = dht.readTemperature();
    hum = dht.readHumidity();
    sol = analogRead(0);

    Serial.print("T:");
    Serial.print(temp);
    Serial.print(", H: ");
    Serial.print(hum);
    Serial.print(", S: ");
    Serial.print(sol);

    rgbLcd.setCursor(0,0);
    rgbLcd.print("T: "); 
    rgbLcd.print(temp);
    rgbLcd.print(" H: "); 
    rgbLcd.print(hum); 
    rgbLcd.setCursor(0,1);
    rgbLcd.print("S: "); 
    rgbLcd.print(sol); 

    Serial.print(", P: ");
    if((sol) < (500)){
        digitalWrite(2,1);
        Serial.print("1;");
    } else {
        digitalWrite(2,0);
        Serial.print("0;");
    }

    Serial.println();


    _delay(.4);
    _loop();
}



