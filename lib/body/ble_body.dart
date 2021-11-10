import 'dart:math';
import '/body/Chart/chart_flow.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import '../BlueTooth/model/notifiction_value.dart';
import '../serices/alarm_notifiction.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:battery_indicator/battery_indicator.dart';
import '../settings/oparation_ble.dart';
import '../BlueTooth/model/write_value.dart';
import 'dart:async';

class CreatBoxForDevice extends StatefulWidget {
  static ValueNotifier<bool> ststusConnection = ValueNotifier(true);
  static ValueNotifier<int> batteryDevice = ValueNotifier(0);
  static ValueNotifier<int> rssiDevice = ValueNotifier(0);
  static ValueNotifier<int> rssiPhone = ValueNotifier(0);

  static ValueNotifier<int> moveXdevice = ValueNotifier(0);
  static ValueNotifier<int> moveYdevice = ValueNotifier(0);
  static ValueNotifier<int> moveZdevice = ValueNotifier(0);

  final Peripheral device;
  const CreatBoxForDevice(this.device, {Key? key}) : super(key: key);

  @override
  _CreatBoxForDeviceState createState() => _CreatBoxForDeviceState();
}

class _CreatBoxForDeviceState extends State<CreatBoxForDevice> {
  int _avgRssi = 0;
  bool _status = true;
  bool _move = false;
  var dis;
  bool valNotify = true;
  bool startAlarm = false;
  late StreamSubscription<PeripheralConnectionState> subscription;
  bool _flagConnect = true;
  BleManager bleManager = BleManager();
  late String identifier;
  onChangeFunction(bool newValue) async {
    await disconnectDevice(widget.device);
    //widget.device.disconnect();
    setState(() {
      _flagConnect = newValue;
      _status = newValue;
    });
  }

  _notificationMovment() {
    setState(() {
      _move = true;
    });
  }

  _checkState() async {
    //subscription =
    widget.device.observeConnectionState().listen((event) {
      setState(() {
        if (event.index == 1) {
          _status = true;
          if (CreatBoxForDevice.rssiDevice.value == 0 || _flagConnect) {
            // creatNotici();
            _flagConnect = true;
          }
        } else {
          _status = false;
          bleManager.startPeripheralScan().listen((scanResult) async{
            if (identifier == scanResult.peripheral.identifier)  {
              bleManager.stopPeripheralScan();
              await scanResult.peripheral.connect();
              creatNotici();
              setState(() {
                _status = true;
              });
            }
          });
        }
      });
    });
  }

  scanForDevice() async {
    await bleManager.createClient();

    //List<String> temp = DeviceMac().MacList;
    bleManager.startPeripheralScan().listen((scanResult) {
      if (identifier == scanResult.peripheral.identifier) {
        setState(() {
          // DeviceMac().addMaceAddress(scanResult.peripheral.identifier);
          //temp.add(scanResult.peripheral.identifier);
          widget.device.connect();
          bleManager.stopPeripheralScan();
          //devices.add(scanResult.peripheral);
        });
      }
    });
  }

  creatNotici() {
    createNotifiction(widget.device, _notificationMovment);
  }

  @override
  void initState() {
    identifier = widget.device.identifier;
    _checkState();
    NotificationApi.init();
    listenNotifications();
    createNotifiction(widget.device, _notificationMovment);
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) =>
      Alert(context: context, type: AlertType.error, desc: "Alert", buttons: [
        DialogButton(
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ]).show();

  creatAlart() {
    NotificationApi.showNofication(
      title: 'Alert',
      body: 'Bag Is Moving',
      payload: 'sarah.adb',
    );
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: startAlarm ? Colors.red : Colors.green[200],
      margin: EdgeInsets.all(10),
      child: ExpansionTile(
        childrenPadding:
            EdgeInsetsDirectional.only(top: 30, start: 30, bottom: 10),
        backgroundColor: Colors.white12,
        title: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(
                  width: 6,
                ),
                Text(
                  'QPower',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              BatteryIndicator(
                batteryFromPhone: false,
                batteryLevel:
                    _status ? CreatBoxForDevice.batteryDevice.value : 0,
                style: BatteryIndicatorStyle.skeumorphism,
                colorful: true,
                showPercentNum: true,
                mainColor: Colors.black26,
                size: 8,
                ratio: 2,
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: WidgetCircularAnimator(
                innerAnimation: Curves.easeInOutBack,
                innerColor: _status ? Colors.blueAccent : Colors.grey,
                outerColor: Colors.green,
                singleRing: !_status,
                innerAnimationSeconds: 3,
                size: 95,
                child: Container(
                  child: Icon(Icons.bluetooth_audio),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _status
                        ? (_move ? Colors.yellow[300] : Colors.green[300])
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ValueListenableBuilder(
                  valueListenable: CreatBoxForDevice.rssiDevice,
                  builder: (context, int valueDevice, child) {
                    widget.device.rssi().then((value) {
                      CreatBoxForDevice.rssiPhone.value = value;
                      _avgRssi = ((-valueDevice + value) / 2).round();
                      setState(() {
                        if (_avgRssi < -80 &&
                                _move &&
                                BuildOperation.thiefStatus.value ||
                            _avgRssi < -85 &&
                                BuildOperation.forgetStatus.value) {
                          setState(() {
                            startAlarm = true;
                          });
                          FlutterBeep.playSysSound(
                              AndroidSoundIDs.TONE_CDMA_ALERT_CALL_GUARD);
                          creatAlart();
                        } else {
                          setState(() {
                            startAlarm = false;
                          });
                        }
                        dis = double.parse((pow(10, ((-65 - (_avgRssi)) / 20))
                            .toStringAsFixed(1)));
                        _move = false;
                      });
                    });
                    return dataCreat("Signal Stength db", _avgRssi);
                  }),
              // dataCreat("Signal Stength db", _avgRssi),
              dataCreat("Estimated Distance", dis),
            ]),
          ]),
        ]),
        onExpansionChanged: (value) {
          if (value) {
            showModalBottomSheet(
                context: context, builder: (context) => ChartFlow());
          }
        },
        children: [
          BuildOperation(device: widget.device, status: onChangeFunction),
        ],
      ),
    );
  }

  Widget dataCreat(String text, var data) {
    List<String> splitText = text.split(" ");
    bool Rssi = false;
    if (splitText.length > 2) {
      Rssi = true;
    }
    return Column(
      children: [
        Text(
          splitText[0],
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
        ),
        Text(
          splitText[1],
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
        ),
        SizedBox(
          height: 5,
          width: 10,
        ),
        Text(
          _status
              ? Rssi
                  ? '$data${splitText[2]}'
                  : '$data'
              : '-',
          style: TextStyle(
            fontSize: 15,
          ),
        )
      ],
    );
  }
}
