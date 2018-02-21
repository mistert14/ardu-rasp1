#include "Arduino.h"

#include <Wire.h>
#include "rgb_lcd.h"
#include "DHT.h"


char receivedChar;
boolean newData = false;


double capteur;

DHT dht(4, 11);

char buffer[20];

rgb_lcd rgbLcd;

void _loop() {

}


void recvOneChar() {
 if (Serial.available() > 0) {
 receivedChar = Serial.read();
 newData = true;
 }
}


void processData(float temp, float hum,float sol) {
 if (newData == true) {
    if (receivedChar=='@') {
    Serial.print("T:");
    Serial.print(temp);
    Serial.print(", H: ");
    Serial.print(hum);
    Serial.print(", S: ");
    Serial.print(sol);
    Serial.println();
 } 
 else if (receivedChar=='P') {
    Serial.println("Pompe on");
    digitalWrite(2,HIGH);
 }
 else if (receivedChar=='p') {
    Serial.println("Pompe off");
    digitalWrite(2,LOW);
 }

 newData = false;
 }
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

    float temp = dht.readTemperature();
    //temp = dht.temperature;
    float hum = dht.readHumidity();
    float sol = analogRead(0);

    recvOneChar();
    processData(temp,hum,sol);


    rgbLcd.setCursor(0,0);
    rgbLcd.print("T: "); 
    rgbLcd.print(temp);
    rgbLcd.print(" H: "); 
    rgbLcd.print(hum); 
    rgbLcd.setCursor(0,1);
    rgbLcd.print("S: "); 
    rgbLcd.print(sol); 



    _delay(.4);
    _loop();
}



