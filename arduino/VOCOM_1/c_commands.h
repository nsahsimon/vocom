
#ifndef _COMMANDS_
class Commands {
  
  String allCommands[10]= {
    "turn on the light", // 0
    "turn off the light",// 1
    "enable learning mode", //2
    "disable learning mode",//3
    "add"//4
    };
  int index = 4; // this is the length of predefine instructions

  public: 
    Commands(){}
    bool isCmdValid(String cmd){
      for(int i = 0; i < 10; i++){
        if(cmd == allCommands[i]){
          Serial.println("Valid Command");
          return true;
        }
      }
      Serial.println("Invalid Command");
      return false;
    }

    void addCommand(String cmd) {
      index++;
      allCommands[index] = cmd;
    }
};

Commands myCommands;
#define _COMMANDS_
#endif
