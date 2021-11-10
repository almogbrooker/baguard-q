import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connect_status.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BluethootDeviceLowPower extends StatefulWidget {
  final Function connectMain;
  const BluethootDeviceLowPower({
    Key? key,
    required this.connectMain,
  }) : super(key: key);
  _StateBluethootDeviceLowPower createState() =>
      _StateBluethootDeviceLowPower();
}

class _StateBluethootDeviceLowPower extends State<BluethootDeviceLowPower>
    with SingleTickerProviderStateMixin {
  late Timer time;
  List<Peripheral> devices = [];
  BleManager bleManager = BleManager();
  var scanSubscription;
  bool endSearch = false;
  late StreamSubscription streamSub;

  scanForDevice() async {
    await bleManager.createClient();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.locationWhenInUse,
    ].request();
    List<String> temp = DeviceMac().MacList;
    streamSub = bleManager.startPeripheralScan().listen((scanResult) {
      if (scanResult.peripheral.name == "QPOWER") {
        if (!temp.contains(scanResult.peripheral.identifier)) {
          setState(() {
            DeviceMac().addMaceAddress(scanResult.peripheral.identifier);
            temp.add(scanResult.peripheral.identifier);
            devices.add(scanResult.peripheral);
          });
        }
      }
    });

    time = Timer(Duration(seconds: 5), () {
      streamSub.cancel();
      setState(() {
        endSearch = true;
      });
    });
  }

  void stopScanning() {
    scanSubscription.cancel();
  }

  @override
  void initState() {
    bleManager.createClient();
    bleManager.observeBluetoothState().listen((state) {
      if (state == BluetoothState.POWERED_OFF) {
        bleManager.enableRadio();
      } else if (state == BluetoothState.POWERED_ON) {
        scanForDevice();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    streamSub.cancel();
    time.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        height: 300,
        child: Column(
          children: [
            Text(
              'Searching',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: !endSearch
                  ? LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.grey,
                      color: Colors.blue,
                    )
                  : devices.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 40, right: 80),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.bluetooth_disabled,
                              size: 100,
                              color: Colors.black38,
                            ),
                          ),
                        )
                      : null,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      widget.connectMain(devices[index]);
                      Navigator.pop(context);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Icon(Icons.bluetooth_connected),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              '${devices[index].name}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ]),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              widget.connectMain(devices[index]);
                            },
                            child: Text('Connect'),
                          ),
                        ]),
                  );
                },
              ),
            ),
            endSearch
                ? ElevatedButton(
                    onPressed: () {
                      scanForDevice();
                      setState(() {
                        endSearch = false;
                      });
                    },
                    child: Text('Try again'),
                  )
                : Text(''),
          ],
        ));
  }
}
