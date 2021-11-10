import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

enum SwitchStatus { Thif, Forget }

class BuildOperation extends StatefulWidget {
  static ValueNotifier<bool> thiefStatus = ValueNotifier(true);
  static ValueNotifier<bool> forgetStatus = ValueNotifier(true);
  final  Peripheral device;
  final Function status;
  const BuildOperation({
    Key? key,
    required this.device,
    required this.status,
  }) : super(key: key);

  @override
  _StateBuildOperation createState() => _StateBuildOperation();
}

class _StateBuildOperation extends State<BuildOperation> {
  bool valNotify = true;
  double slidevalue1 = 4;
  double slidevalue2 = 4;
  String status1 = 'Medium';
  String status2 = 'Medium';
  bool changeConnection = true;

  onChangeFunctionSlide1(double newValue) {
    setState(() {
      if (newValue < 3.4) {
        status1 = 'High ';
      } else if (newValue < 4.7) {
        status1 = 'Medium ';
      } else {
        status1 = 'Low ';
      }
      slidevalue1 = getNumber(newValue, precision: 1);
    });
  }

  onChangeFunctionSlide2(double newValue) {
    setState(() {
      if (newValue < 3.4) {
        status2 = 'High ';
      } else if (newValue < 4.7) {
        status2 = 'Medium ';
      } else {
        status2 = 'Low ';
      }
      slidevalue2 = getNumber(newValue, precision: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        buildNotifyOptionSw(
            'assets/images/alarm.svg', // Icon you want
            'Alert', // title for the row
            'Enable theft alert', // subtitle
            BuildOperation.thiefStatus.value,
            SwitchStatus.Thif // switch or slide animation
            ),
        buildNotifyOptionSw(
            'assets/images/distance.svg', // Icon you want
            'Forget', // title for the row
            'Enable forget alert', // subtitle
            BuildOperation.forgetStatus.value,
            SwitchStatus.Forget // switch or slide animation
            ),
        buildNotifyOptionSl(
          Icons.radar, // Icon you want
          'Movment Sensitivity', // title for the row
          "$status2($slidevalue2\m)", // subtitle
          slidevalue2, // switch or slide animation
          onChangeFunctionSlide2,
        ),
         ElevatedButton(
          onPressed: () {
            widget.status(false);
          },
          child: Text('Disconnect'),
          style: ButtonStyle(),
        ),
      ]),
    );
  }
}

Padding buildNotifyOptionSw(String icon, String title, String subtitle,
    var value, SwitchStatus status) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Icon(Icons.alarm,
                color: status == SwitchStatus.Thif
                    ? BuildOperation.thiefStatus.value
                        ? Colors.green
                        : Colors.red
                    : BuildOperation.forgetStatus.value
                        ? Colors.green
                        : Colors.red,
                size: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: Switch.adaptive(
              activeColor: Colors.blue,
              value: value,
              onChanged: (bool newValue) {
                if (status == SwitchStatus.Thif) {
                  BuildOperation.thiefStatus.value = newValue;
                } else {
                  BuildOperation.forgetStatus.value = newValue;
                }
              }),
        ),
      ],
    ),
  );
}

Padding buildNotifyOptionSl(IconData icon, String title, String subtitle,
    var value, Function boolState) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    child: Column(
      children: [
        Container(
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )
            ],
          ),
        ),
        Transform.scale(
            scale: 1,
            child: Slider.adaptive(
                value: value,
                min: 2,
                max: 6,
                onChanged: (double newValue) {
                  boolState(newValue);
                })),
      ],
    ),
  );
}

double getNumber(double input, {int precision = 2}) =>
    double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1));
