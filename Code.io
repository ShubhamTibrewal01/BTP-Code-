#include <ESP8266WiFi.h>
#include <DHT.h>
#include <ThingSpeak.h>

#define S0 D0
#define S1 D1
#define S2 D2
#define S3 D3
#define analogpin A0

DHT dht(D5, DHT11);

WiFiClient client;

long myChannelNumber = 1439353;
const char myWriteAPIKey[] = "JTBYXHTNUJXIDMW7";

void setup() {
  // put your setup code here, to run once:
  //Serial.begin(9600);
  Serial.begin(115200);
  WiFi.begin("wifiname", "wifipassword");
  while(WiFi.status() != WL_CONNECTED)
  {
    delay(200);
    Serial.print("..");
  }
  Serial.println();
  Serial.println("NodeMCU is connected!");
  Serial.println(WiFi.localIP());
  
  dht.begin(); /// libaray to begin
  ThingSpeak.begin(client);
  
  //For the analog reading
  pinMode(analogpin, INPUT);
  pinMode(S0,OUTPUT);
  pinMode(S1,OUTPUT);
  pinMode(S2,OUTPUT);
  pinMode(S3,OUTPUT);  
  
}

void loop() {
  // For getting th evalue of Temperature and Humidity.
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  Serial.println("Temperature: " + (String) t);
  Serial.println("Humidity: " + (String) h);
  ThingSpeak.writeField(myChannelNumber, 1, t, myWriteAPIKey);//1 field number .
  ThingSpeak.writeField(myChannelNumber, 2, h, myWriteAPIKey);
  
  //For getting the value of Voltage(We can also need to calibration to get the voltage in percentage of battery)
  digitalWrite(S0,LOW);
  digitalWrite(S1,LOW);
  digitalWrite(S2,LOW);
  digitalWrite(S3,LOW);
  int voltage=analogRead(analogpin);
  Serial.print("Sensor 3");
  Serial.println(analogRead(analogpin));
  ThingSpeak.writeField(myChannelNumber, 3, voltage, myWriteAPIKey);
  
  //For getting the value of Current.
  digitalWrite(S0,HIGH);
  digitalWrite(S1,LOW);
  digitalWrite(S2,LOW);
  digitalWrite(S3,LOW);
  int current=analogRead(analogpin);
  Serial.print("Sensor 4");
  Serial.println(analogRead(analogpin));
  ThingSpeak.writeField(myChannelNumber,4, current, myWriteAPIKey);
  
  delay(5000);//delay of 5sec.
}
