import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

String address = '78:D8:FF:00:23:06';
List<BluetoothDevice> devices = [];
bool isConnected = false;
String turnOnMsg = '1';
String turnOffMsg = '0';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterBluetoothSerial bluetooth;
  BluetoothConnection connection;
  bool isLEDOn = false;
  String connectionState = 'Disconnected';
  bool switchState = false;
  BluetoothState myBluetoothState = BluetoothState.UNKNOWN;
  void establishAConnection() async {
    if(myBluetoothState.isEnabled){
      try {
        if (isConnected == false) {
          setState(() {
            connectionState = 'Connecting.....';
          });
          connection = await BluetoothConnection.toAddress(address);
          print('Connected to the device');
          isConnected = true;
          setState(() {
            connectionState = 'Connected';
          });
        }
      } catch (exception) {
        print('cannot connect, an exception occurred');
      }
    }
  }

  void turnLEDOn() {
    if (isConnected && !isLEDOn && myBluetoothState.isEnabled) {
      connection.output.add(ascii.encode(turnOnMsg));
      setState(() {
        isLEDOn = true;
      });
      print('the led is on');
    }
  }

  void turnLEDOff() {
    if (isConnected && isLEDOn && myBluetoothState.isEnabled) {
      connection.output.add(ascii.encode(turnOffMsg));
      setState(() {
        isLEDOn = false;
      });
      print('the led is off');
    }
  }

  //stops and closes any active bluetooth connection.
  Future<void> disableConnection() async {
    if (isConnected && myBluetoothState.isEnabled) {
      await connection.finish();
      await connection.close();
      connection.dispose();
      isConnected = false;
      print('device is disconnected');
      setState(() {
        connectionState = 'Disconnected';
      });
    } else {
      print('Bluetooth is already disabled');
    }
  }

  // this outputs a list of devices paired with your device.
  void displayBluetoothDevices() async {
    if(myBluetoothState.isEnabled){
      try {
        devices = await FlutterBluetoothSerial.instance.getBondedDevices();
        devices.forEach((device) {
          print(
              'device name: ${device.name}   device address: ${device.address}');
        });
      } on PlatformException {
        print('an error occurred');
      }
    }
    }


  updateBluetoothState() async {
    await FlutterBluetoothSerial.instance.state.then(
      (BluetoothState state) {
        setState(
          () {
            myBluetoothState = state;
          },
        );
      },
    );
  }

  @override
  void initState() {
    //listening for any changes in the  bluetooth state as the program is running
    updateBluetoothState();
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        myBluetoothState = state;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //free up the memory
    connection.dispose();
    connection = null;
  }

  @override
  Widget build(BuildContext context) {
    print('build method executed');
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Center(child: Text(connectionState)),
            actions: [
              Switch(
                value: myBluetoothState.isEnabled,
                onChanged: (val) async {
                  if (val) {
                    await FlutterBluetoothSerial.instance.requestEnable();
                    print(myBluetoothState.isEnabled);
                  } else {
                    await disableConnection();
                    await FlutterBluetoothSerial.instance.requestDisable();
                  }
                },
                activeColor: Colors.red,
              ),
            ],
          ),
          backgroundColor: Colors.teal,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                          onPressed: turnLEDOn,
                          color: Colors.green,
                          child: !isLEDOn ? Text('ON') : null),
                      FlatButton(
                          onPressed: turnLEDOff,
                          color: Colors.red,
                          child: isLEDOn ? Text('OFF') : null),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: establishAConnection,
                  height: 50,
                  color: Colors.yellow,
                  minWidth: 80,
                  child: Text(
                    'Connect',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: disableConnection,
                  height: 50,
                  color: Colors.red,
                  minWidth: 80,
                  child: Text(
                    'disconnect',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                FlatButton(
                  onPressed: displayBluetoothDevices,
                  height: 30,
                  color: Colors.pink,
                  minWidth: 80,
                  child: Text(
                    'show bluetooth devices',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData.dark(),
    );
  }
}
