#include <SoftwareSerial.h>

#define rxPin 0
#define txPin 1

#define DEBUG_ENABLED 1
char myChar;

SoftwareSerial bt(rxPin, txPin); // RX, TX

void setup(){
  pinMode(rxPin,INPUT);
  pinMode(txPin,OUTPUT);

  Serial.begin(9600); // Begin the serial monitor at 9600bps

  delay(100); // Short delay, wait for the Mate to send back CMD
  bt.begin(9600); // Start bluetooth serial at 9600
  Serial.flush();
  bt.flush();

}



void loop(){

  Serial.println('On part ...'); // Begin the serial monitor at 9600bps
 
  while(bt.available()){
    myChar = bt.read();
    Serial.println(myChar);
  }

  while(Serial.available()){
   myChar = (char)Serial.read();
   bt.println(myChar);
  }
}
