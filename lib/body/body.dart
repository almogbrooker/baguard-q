import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import '/body/ble_body.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/connect_status.dart';

class BodyList extends StatefulWidget {
  static ValueNotifier<List<String>> deviceConnect = ValueNotifier([]);

  BodyList({
    Key? key,
  }) : super(key: key);
  @override
  _BodyListState createState() => _BodyListState();
}

class _BodyListState extends State<BodyList> {
  BleManager bleManager = BleManager();
  List<Peripheral> devices = [];
  bool _status = false;
  Widget deletBgItem() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      margin: EdgeInsets.all(10),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  _checkState(int index) async {
    //subscription =
    devices[index].observeConnectionState().listen((event) {
      setState(() {
        if (event.index == 2) {
          _status = true;
          //if (CreatBoxForDevice.rssiDevice.value == 0 || _flagConnect) {
          // creatNotici();
          //_flagConnect = true;
        } else {
          _status = false;
          //widget.device.connect();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  void disconnect(int index) async {
    List<String> temp;
    //temp = prefs.getStringList('connect') ?? [];
    //temp.remove(devices[index].id.id);
    //prefs.setStringList('connect', temp);
    context.watch<DeviceMac>().RemoveMac(index);
    devices[index].disconnectOrCancelConnection();
    setState(() {
      devices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      alignment: Alignment.center,
      child: ListView.builder(
          itemCount: context.watch<DeviceMac>().Devices.length,
          itemBuilder: (context, index) {
            devices = context.watch<DeviceMac>().Devices;
            // _checkState(index);
            return Dismissible(
                key: Key(devices[index].identifier),
                onDismissed: (direction) {
                  disconnect(index);
                },
                background: deletBgItem(),
                child: CreatBoxForDevice(devices[index]));
          }),
    );
  }
}
