import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class DeviceMac with ChangeNotifier{  
  List<Peripheral> _Devices= [];
  List<String> _DeviceMacs= [];
  List<Peripheral> get Devices => _Devices;
  List<String> get MacList => _DeviceMacs;

  void addMaceAddress(String device){
    _DeviceMacs.add(device);
    notifyListeners();
  }

  void DeviceList (Peripheral device){
    _Devices.add(device);
    notifyListeners();
  }
  void RemoveMac(int index){
      _DeviceMacs.removeAt(index);
  }
}