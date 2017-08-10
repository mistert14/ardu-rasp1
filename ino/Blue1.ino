#include <SoftwareSerial.h>// import the serial library
#include "TSSerial.h"

TSSerial bt; // RX, TX
int ledpin=2; // led on D13 will show blink on / off
String BluetoothData; // the data given from Computer

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  bt.send(5,"Bluetooth On please press 1 or 0 blink LED ..");
  Serial.println("Bluetooth On please press 1 or 0 blink LED ..");
  pinMode(ledpin,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
   bt.send(5,String("azerty"));
   Serial.println("azerty");
   delay(500);// prepare for next data ...
}

