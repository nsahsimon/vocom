
#include "a_variables.h"

class SerialData {
  private: 
    String msgString = "";
    char recentMsg[MAX_MSG_LENGTH];
    int counter = 0;

  public: 
    SerialData() {}
    String getMsg();
    void emptyArray();
};


//getMsg retrieves the message sent from the phone

String SerialData::getMsg (){
while (Serial.available() > 0){
      char latestbyte = Serial.read();
   
      //when \n is read,
      //reset the counter
      //render the msg variable
      //terminate the loop
      if(latestbyte == '\n' || latestbyte == '.') 
      {
        counter = 0;
        msgString = recentMsg;
        emptyArray(); //reset data
        break;
      }
      else recentMsg[counter] = latestbyte; 
      
      counter++;
      delay(10);
    }
    return msgString;
}

//emptyArray nullifies the array : recentMsg
void SerialData::emptyArray() {
  for(int counter = 0; counter<100; counter++)
          {
            recentMsg[counter] = '\0';
          }
}
