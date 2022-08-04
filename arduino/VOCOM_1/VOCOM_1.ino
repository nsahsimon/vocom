
#include "a_variables.h"
#include "b_Serial_Data.h"
#include "d_processing.h"
#include "c_commands.h"

Processes myProcesses;

SerialData mySerial;  // Creating an instance of the SerialData Class

String cmd;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
//  Serial.println("please wait...");
//  delay(4000);
//  Serial.println("Ride on");
  
  //Create instances of command Class
  //turn_the_blue_lights_on("turn the blue lights on");
  
  // declare output pins
  pinMode(ledPin,OUTPUT);
 

  //set output pins originally to LOW
  digitalWrite(ledPin,LOW);
  
}


void loop() {
  
//If message is availabe, get it
    if(Serial.available() > 0)
    { 
     cmd = mySerial.getMsg();
     Serial.println(cmd);
     myProcesses.process(cmd);
    }
  }
  
