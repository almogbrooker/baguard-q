import 'package:flutter/material.dart';
import '/logging/screens/screen.dart';
class Splase extends StatefulWidget {
  const Splase({Key? key}) : super(key: key);

  @override
  _SplaseState createState() => _SplaseState();
}

class _SplaseState extends State<Splase> {

  @override
  void initState() {
    _navigatetohome();
    super.initState();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 3000)).then((value) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(20, 112, 104, 0.8),
          image: DecorationImage(
            scale: 2.0,
        image: AssetImage('assets/icon/himalaya.png'),
      )),
      child: Container(
        margin: EdgeInsets.all(30),
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
