String flux="";
long port=0;
int a0;

/*
long stringToLong(String s) {
   char arr[12];
   s.toChararray(arr,sizeof(arr));
   return atol(arr);

}

char* stringToArr(String s) {
   char arr[12];
   s.toChararray(arr,sizeof(arr));
   return arr;
}
*/

void setup() {
   Serial.begin(115200);
   Serial.println("a l'écoute ...");   
}

void loop() {
   while (Serial.available()>0) {
      char data= Serial.read();
      flux += data;
      delay(1);

      if (data == '#') {
        a0 = analogRead(0);
        Serial.print("a0:");
        Serial.println(a0);
        flux="";
        Serial.flush();
      }
   }
}
