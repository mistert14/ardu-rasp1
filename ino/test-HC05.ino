#include <SoftwareSerial.h>                         // Software Serial Port
#define RxD         7
#define TxD         6

#define DEBUG_ENABLED  1

SoftwareSerial btSerial(RxD,TxD);

void setupBlueToothConnection()
{
        btSerial.begin(9600);  
	btSerial.print("AT");
	delay(400); 
	btSerial.print("AT+DEFAULT");             // Restore all setup value to factory setup
	delay(2000); 
	btSerial.print("AT+NAMESeeedMaster");    // set the bluetooth name as "SeeedMaster" ,the length of bluetooth name must less than 12 characters.
	delay(400);
	btSerial.print("AT+ROLEM");             // set the bluetooth work in slave mode
	delay(400); 
	btSerial.print("AT+AUTH1");            
        delay(400);    
	btSerial.print("AT+CLEAR");             // Clear connected device mac address
        delay(400);   
        btSerial.flush();
}

void setup()
{
    pinMode(RxD, INPUT);
    pinMode(TxD, OUTPUT);

    Serial.begin(9600);
    setupBlueToothConnection();
    
    //wait 1s and flush the serial buffer
    delay(1000);
    Serial.flush();
    btSerial.flush();
}

void loop()
{
  btSerial.println("Echo server");
  while (1 == 1) 
  {
    if (btSerial.available()) {
      Serial.write(btSerial.read());
      btSerial.write(btSerial.read());
    }
  }
}

