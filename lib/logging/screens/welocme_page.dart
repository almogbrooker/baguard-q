import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
import '../widgets/widgets.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image(
                          image: AssetImage('assets/images/sigh_up_image.png')),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: kHeadline,
                  ),
                ],
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: 70),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: MyTextButton(
                        bgColor: Colors.greenAccent,
                        buttonName: 'Register',
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: 30),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: MyTextButton(
                        bgColor: Colors.greenAccent,
                        buttonName: 'Log in',
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                        textColor: Colors.black,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
