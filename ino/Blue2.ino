#include <SoftwareSerial.h>
int rx_pin = 6;     // setting digital pin 6 to be the receiving pin
int tx_pin = 7;     // setting the digital pin 7 to be the transmitting pin

SoftwareSerial Bt(rx_pin,tx_pin); // this creates a new SoftwareSerial object on 


void bluetoothInitiate(){
 // this part is copied from the Seeeduino example*
 Bt.begin(38400); // this sets the the module to run at the default bound rate
 Bt.print("\r\n+STWMOD = 0\r\n");        //set the bluetooth work in slave mode
 Bt.print("\r\n+STBD=38400\r\n");
 Bt.print("\r\n+STNA=SeeedBTSlave\r\n"); //set the bluetooth name as "SeeedBTSlave"
 Bt.print("\r\n+STOAUT=1\r\n");          // Permit Paired device to connect me
 Bt.print("\r\n+STAUTO=0\r\n");          // Auto-connection should be forbidden here
 delay(2000);                            // This delay is required.
 Bt.print("\r\n+INQ=1\r\n");             //make the slave bluetooth inquirable
 delay(2000);                            // This delay is required.
 Bt.flush(); 
 Bt.print("Bluetooth connection established correctly!"); // if connection is successful then print to the master device
}
                                   // the selected pins!
void setup(){ 
 Serial.begin(9600); // this is a connection between the arduino and 
                       // the pc via USB
 pinMode(rx_pin, INPUT);  // receiving pin as INPUT
 pinMode(tx_pin, OUTPUT); // transmitting pin as OUTPUT
 bluetoothInitiate(); // this function will initiate our bluetooth (next section)
}  
   
void loop(){
 char buffer; // this is where we are going to store the received character
 if(Bt.available()){     // this will check if there is anything being
                           // sent to the Bluetooth from another device
   buffer = Bt.read();   // this will save anything that is being sent to the Bluetooth
   Serial.print(buffer); // this will print to the local serial (tools->serial monitor)
   }
 // this is for recieving on the device with bluetooth, now we can make it send stuff too!
 if(Serial.available()){   // this will check if any data is sent
                             // from the local terminal
   buffer = Serial.read(); // get what the terminal sent
   Bt.print(buffer);       // and now send it to the master device
   }
 
 }  

