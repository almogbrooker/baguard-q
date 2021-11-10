import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/body/ble_body.dart';
import 'dart:async';


enum SelectArry {
  RssiDevice,
  RssiPhone,
  RssiAvg,
  MovementX,
  MovementY,
  MovementZ,
}
int count = 0;

class ChartFlow extends StatefulWidget {
  ChartFlow({Key? key}) : super(key: key);

  @override
  _ChartLiveState createState() => _ChartLiveState();
}

class _ChartLiveState extends State<ChartFlow> {
  int rssiDevice = 0;
  int rssiPhone = 0;
  int rssiAvg = 0;

  List<ReadData> chartRssiDevice = [];
  List<ReadData> chartRssiPhone = [];
  List<ReadData> chartRssiAvg = [];
  List<ReadData> chartMovementX = [];
  List<ReadData> chartMovementY = [];
  List<ReadData> chartMovementZ = [];

  late ChartSeriesController _chartSeriesControllerRssiPhone;
  late ChartSeriesController _chartSeriesControllerRssiDevice;
  late ChartSeriesController _chartSeriesControllerRssiAvg;
  late ChartSeriesController _chartSeriesControllerMovementX;
  late ChartSeriesController _chartSeriesControllerMovementY;
  late ChartSeriesController _chartSeriesControllerMovementZ;
  int count = 2;

  @override
  void initState() {
    chartRssiDevice = creatArray();
    chartRssiPhone = creatArray();
    chartRssiAvg = creatArray();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ValueListenableBuilder(
              valueListenable: CreatBoxForDevice.rssiPhone,
              builder: (context, value, child) {
                count++;
                rssiDevice = CreatBoxForDevice.rssiDevice.value.abs();
                rssiPhone = CreatBoxForDevice.rssiPhone.value.abs();
                rssiAvg = (rssiDevice + rssiPhone) ~/ 2;
                updateData(chartRssiPhone, rssiPhone, SelectArry.RssiPhone);
                updateData(chartRssiDevice, rssiDevice, SelectArry.RssiDevice);
                updateData(chartRssiAvg, rssiAvg, SelectArry.RssiAvg);

                return SfCartesianChart(
                  series: [
                    LineSeries<ReadData, int>(
                      name: 'RSSI Phone',
                      onRendererCreated: (ChartSeriesController controller) {
                        _chartSeriesControllerRssiPhone = controller;
                      },
                      markerSettings:
                          MarkerSettings(isVisible: true, color: Colors.amber),
                      dataSource: chartRssiPhone,
                      color: Colors.blue,
                      xValueMapper: (ReadData sales, _) => sales.time,
                      yValueMapper: (ReadData sales, _) => sales.data,
                    ),
                    LineSeries<ReadData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _chartSeriesControllerRssiDevice = controller;
                      },
                      name: 'RSSI Device',
                      dataSource: chartRssiDevice,
                      color: Colors.black26,
                      markerSettings:
                          MarkerSettings(isVisible: true, color: Colors.blue),
                      xValueMapper: (ReadData sales, _) => sales.time,
                      yValueMapper: (ReadData sales, _) => sales.data,
                      dataLabelSettings: DataLabelSettings(
                        showCumulativeValues: false,
                        margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                        alignment: ChartAlignment.center,
                        labelPosition: ChartDataLabelPosition.inside,
                        isVisible: false,
                        color: Colors.black26,
                        textStyle: TextStyle(fontSize: 6),
                      ),
                    ),
                    LineSeries<ReadData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _chartSeriesControllerRssiAvg = controller;
                      },
                      name: 'RSSI Avg',
                      dataSource: chartRssiAvg,
                      color: Colors.white,
                      markerSettings:
                          MarkerSettings(isVisible: true, color: Colors.blue),
                      xValueMapper: (ReadData sales, _) => sales.time,
                      yValueMapper: (ReadData sales, _) => sales.data,
                      dataLabelSettings: DataLabelSettings(
                        showCumulativeValues: false,
                        margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                        alignment: ChartAlignment.center,
                        labelPosition: ChartDataLabelPosition.inside,
                        isVisible: false,
                        color: Colors.amberAccent,
                        textStyle: TextStyle(fontSize: 6),
                      ),
                    ),
                  ],
                  title: ChartTitle(text: ("RSSI Chart")),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: NumericAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 10,
                      title: AxisTitle(text: 'Time (seconds)')),
                  primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(size: 0),
                      interval: 5,
                      maximum: 100,
                      minimum: 30,
                      title: AxisTitle(text: 'Rssi')),
                );
              }),
          ValueListenableBuilder(
            valueListenable: CreatBoxForDevice.moveXdevice,
            builder: (context, value, child) {
              count++;
              updateData(chartMovementX, CreatBoxForDevice.moveXdevice.value,
                  SelectArry.MovementX);
              updateData(chartMovementZ, CreatBoxForDevice.moveYdevice.value,
                  SelectArry.MovementY);
              updateData(chartMovementX, CreatBoxForDevice.moveZdevice.value,
                  SelectArry.MovementZ);

              return SfCartesianChart(
                series: [
                  LineSeries<ReadData, int>(
                    name: 'MovmentX',
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerMovementX = controller;
                    },
                    markerSettings:
                        MarkerSettings(isVisible: true, color: Colors.amber),
                    dataSource: chartMovementX,
                    color: Colors.blue,
                    xValueMapper: (ReadData sales, _) => sales.time,
                    yValueMapper: (ReadData sales, _) => sales.data,
                  ),
                  LineSeries<ReadData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerMovementY = controller;
                    },
                    name: 'MovmentY',
                    dataSource: chartMovementY,
                    color: Colors.red,
                    markerSettings:
                        MarkerSettings(isVisible: true, color: Colors.blue),
                    xValueMapper: (ReadData sales, _) => sales.time,
                    yValueMapper: (ReadData sales, _) => sales.data,
                    dataLabelSettings: DataLabelSettings(
                      showCumulativeValues: false,
                      margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                      alignment: ChartAlignment.center,
                      labelPosition: ChartDataLabelPosition.inside,
                      isVisible: false,
                      color: Colors.black26,
                      textStyle: TextStyle(fontSize: 6),
                    ),
                  ),
                  LineSeries<ReadData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesControllerMovementZ = controller;
                    },
                    name: 'MovmentZ',
                    dataSource: chartMovementZ,
                    color: Colors.green,
                    markerSettings:
                        MarkerSettings(isVisible: true, color: Colors.blue),
                    xValueMapper: (ReadData sales, _) => sales.time,
                    yValueMapper: (ReadData sales, _) => sales.data,
                    dataLabelSettings: DataLabelSettings(
                      showCumulativeValues: false,
                      margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                      alignment: ChartAlignment.center,
                      labelPosition: ChartDataLabelPosition.inside,
                      isVisible: false,
                      color: Colors.amberAccent,
                      textStyle: TextStyle(fontSize: 6),
                    ),
                  ),
                ],
                title: ChartTitle(text: ("Movment")),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 10,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    interval: 5,
                    maximum: 70,
                    minimum: 20,
                    title: AxisTitle(text: 'Movment')),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateData(
      List<ReadData> array, int value, SelectArry select) async {
    array.add(ReadData(value, count));

    if (array.length > 20) {
      array.removeAt(0);
    }
    switch (select) {
      case SelectArry.RssiPhone:
        {
          _chartSeriesControllerRssiPhone.updateDataSource(
              addedDataIndex: array.length - 1, removedDataIndex: 0);
        }
        break;
      case SelectArry.RssiDevice:
        {
          _chartSeriesControllerRssiDevice.updateDataSource(
              addedDataIndex: array.length - 1, removedDataIndex: 0);
        }
        break;
      case SelectArry.RssiAvg:
        {
          _chartSeriesControllerRssiAvg.updateDataSource(
              addedDataIndex: array.length - 1, removedDataIndex: 0);
        }
        break;
      case SelectArry.MovementX:
        {
          _chartSeriesControllerMovementX.updateDataSource(
              addedDataIndex: array.length - 1, removedDataIndex: 0);
        }
        break;
      case SelectArry.MovementY:
        {
          _chartSeriesControllerMovementY.updateDataSource(
              addedDataIndex: array.length - 1, removedDataIndex: 0);
        }
        break;
      case SelectArry.MovementZ:
        {
          _chartSeriesControllerMovementZ.updateDataSource(
              addedDataIndex: array.length - 1, removedDataIndex: 0);
        }
        break;
    }
  }
}

List<ReadData> creatArray() {
  return <ReadData>[
    ReadData(40, 0),
    ReadData(40, 1),
  ];
}

class ReadData {
  ReadData(this.data, this.time);
  final int data;
  final int time;
}
