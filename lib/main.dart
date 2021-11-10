import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:provider/provider.dart';
import 'Appbar/appbar.dart';
import 'BlueTooth/search_device.dart';
import 'body/body.dart';
import '/body/back_ground_image.dart';
import 'splash.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '/logging/constants.dart';
import '/providers/connect_status.dart';

Future main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DeviceMac()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baguard',
      home: Splase(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static ValueNotifier<bool> ststusConnection = ValueNotifier(false);

  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> connect(Peripheral device) async {
    await device
        .connect(isAutoConnect: true, timeout: Duration(seconds: 6))
        .then((value) {
      context.read<DeviceMac>().DeviceList(device);
      context.read<DeviceMac>().addMaceAddress(device.identifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImageWidget(
        image: AssetImage('assets/bag.png'),
        child: Scaffold(
          appBar: AppBarQ(
            context: context,
          ),
          drawer: DrawerQ(),
          backgroundColor: Colors.transparent,
          body: BodyList(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            splashColor: Colors.black,
            backgroundColor: Colors.teal,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => BluethootDeviceLowPower(connectMain: connect));
            },
          ),
        ));
  }
}
