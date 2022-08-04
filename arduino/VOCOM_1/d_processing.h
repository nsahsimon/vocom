
#include "c_commands.h"
#include "a_variables.h"
#ifndef _PROCESSING.H_
class Processes {
  private: 
    
    String currentCmd;
  public:
    Processes(){}
    void process(String cmd){
      currentCmd = cmd;
      if(myCommands.isCmdValid(cmd) || isLearning){
        //all the processing code here
          if(cmd == "enable learning mode") 
          {
            Serial.println("______________LEARNING MODE ENABLED_____________");
            isLearning = true;
          }
          else if(cmd == "disable learning mode") 
          {
            Serial.println("_____________LEARNING MODE DISABLED_________");
            isLearning = false;
          }
          else if(isLearning){
            learn();
          }
      
          else execute();

      }
    }

    void learn();

    void execute();
};

void Processes::execute() {
  if(!isLearning){
    if(currentCmd == "turn on the light"){
    digitalWrite(ledPin,HIGH);
    }

    if(currentCmd == "turn off the light"){
      digitalWrite(ledPin,LOW);
    }
    }
} 

void Processes::learn() {
  myCommands.addCommand(currentCmd);
  Serial.println("The command was added");
}
#define _PROCESSING.H_
#endif
