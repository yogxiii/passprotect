import 'package:flutter/material.dart';
import 'package:pass_protect/constant.dart';
import 'package:pass_protect/pages/setmasterpasword.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/lock.png',
              height: 0.3 * size.height,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8),
              child: Text(
                "Welcome To PassProtect",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8),
              child: Text(
                "PassProtect uses AES encryption to takes care of your sensitive password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'subtitle',
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8),
              child: Text(
                "Set Your master password to get strated.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'title',
                    fontSize: 26,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 60,
              width: size.width * 0.7,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetMasterPassword()));
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(kColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)))),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
