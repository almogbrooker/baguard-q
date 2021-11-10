import 'dart:math';

import 'package:flutter/widgets.dart';

import '/body/ble_body.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

const String battery = '180f';
const String batteryvalue = '2a19';
const String rssi = '181c';
const String moveX = '1820';
const String moveY = '1821';
const String moveZ = '1822';

 Future createNotifiction(Peripheral device, Function movementF) async {
  //List<BluetoothService> services = await device.discoverServices();
  List<Characteristic> c;
  List<String> uuidList = [battery, rssi, moveX, moveY, moveZ, batteryvalue];
  await device.discoverAllServicesAndCharacteristics().then((value) async {
   device.services().then((value) {
      value.forEach((server) {
        //var chars = server.uuid.toString().substring(4, 8);
        //if (uuidList.contains(chars)) {
        server.characteristics().then((value) {
          //var chars = server.uuid.toString().substring(4, 8);
          value.forEach((element) {
            var chars = element.uuid.toString().substring(4, 8);
            switch (chars) {
              case rssi:
                {
                  element.monitor().listen((event) {
                    CreatBoxForDevice.rssiDevice.value = event.first;
                  });
                }
                break;
              case batteryvalue:
                {
                  element.monitor().listen((event) {
                    CreatBoxForDevice.batteryDevice.value = event.first;
                  });
                }
                break;
              case moveX:
                {
                  element.monitor().listen((event) {
                    CreatBoxForDevice.moveXdevice.value = event.first;
                    movementF();
                  });
                }
                break;
              case moveY:
                {
                  element.monitor().listen((event) {
                    CreatBoxForDevice.moveYdevice.value = event.first;
                    movementF();
                  });
                }
                break;
              case moveZ:
                {
                  element.monitor().listen((event) {
                    CreatBoxForDevice.moveZdevice.value = event.first;
                    movementF();
                  });
                }
                break;
            }
          });
        });
      });
    });
  });
  
}
