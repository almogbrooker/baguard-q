import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

const String write = '181a';

Future<void> disconnectDevice(Peripheral device) async {
  List<Characteristic> c;
  await device.discoverAllServicesAndCharacteristics();
  List<Service> services = await device.services();
  services.forEach((element) async {
    var chars = element.uuid.toString().substring(4, 8);
    if (chars == write) {
      element.characteristics().then((value) {
        value.forEach((element) {});
      });
    }
  });
}
