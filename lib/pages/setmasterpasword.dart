import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'homepage.dart';

import '../constant.dart';

class SetMasterPassword extends StatefulWidget {
  @override
  _SetMasterPasswordState createState() => _SetMasterPasswordState();
}

class _SetMasterPasswordState extends State<SetMasterPassword> {
  TextEditingController masterPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isStrong = false;

  Future<Null> getMasterPassword() async {
    final storage = FlutterSecureStorage();
    String masterPassword = await storage.read(key: 'master') ?? '';
    masterPasswordController.text = masterPassword;
  }

  void clearText1(){
    masterPasswordController.clear();
  }
  void clearText2()
  {
    confirmPasswordController.clear();
  }

//  @override
//  void dispose(){
//    masterPasswordController.dispose();
//    confirmPasswordController.dispose();
//    super.dispose();
//  }

  void setMasterPassword(String pass) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'master', value: pass);
  }

  final LocalAuthentication auth = LocalAuthentication();
  Future<bool> authenticateIsAvailable() async {
    final isAvailable = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  void authenticate() async {
    //final isAvailable = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    if (isDeviceSupported) {
      bool isAuthenticated = await auth.authenticate(
          localizedReason: "Please Authenticate", stickyAuth: true);
      if (!isAuthenticated) Navigator.pop(context);
    } else
      print("----------------error-----------------");
  }

  @override
  void initState() {
    super.initState();
    //authenticate();
    getMasterPassword();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  margin: EdgeInsets.only(top: size.height * 0.04),
                  child: Text(
                    'Master Password',
                    style: TextStyle(
                        fontSize: 34,
                        fontFamily: 'title',
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Text(
                  'Set Master Passwords for your all passwords. Keep your Master Password safe with you. This password will be used to unlock your encrypted passwords',
                  style: TextStyle(fontFamily: 'subtitle', fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  obscureText: true,
                  maxLength: 16,
                  cursorColor: kColor,
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontFamily: 'subtitle', fontSize: 18.0),
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: clearText1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  controller: masterPasswordController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  obscureText: true,
                  maxLength: 16,
                  cursorColor: kColor,
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontFamily: 'subtitle', fontSize: 18.0),
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: clearText2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  controller: confirmPasswordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FlutterPwValidator(
                    width: size.width * 0.9,
                    height: 115,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    specialCharCount: 1,
                    numericCharCount: 1,
                    defaultColor: Colors.grey,
                    failureColor: Colors.grey.shade600,
                    successColor: kColor,
                    onSuccess: () {
                      print('success');
                      setState(() {
                        isStrong = true;
                      });
                    },
                    controller: masterPasswordController),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
                child: Center(
                  child: SizedBox(
                    height: 60.0,
                    width: size.width * 0.7,
                    child: TextButton(
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(fontFamily: 'title', fontSize: 20),
                      ),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(kColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (masterPasswordController.text.isNotEmpty &&
                            confirmPasswordController.text.isNotEmpty) {
                          if (!isStrong) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Error',
                                      style: TextStyle(fontFamily: 'title'),
                                    ),
                                    content: Text(
                                      "Passwords is not strong enough",
                                      style: TextStyle(fontFamily: "subtitle"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('CLOSE'))
                                    ],
                                  );
                                });
                          } else if (masterPasswordController.text ==
                              confirmPasswordController.text) {
                            setMasterPassword(
                                masterPasswordController.text.trim());
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Error',
                                      style: TextStyle(fontFamily: 'title'),
                                    ),
                                    content: Text(
                                      "Passwords do not match, retype again",
                                      style: TextStyle(fontFamily: "subtitle"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('CLOSE'))
                                    ],
                                  );
                                });
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error',
                                    style: TextStyle(fontFamily: 'title'),
                                  ),
                                  content: Text(
                                    "Please enter valid Master Password.",
                                    style: TextStyle(fontFamily: "subtitle"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('CLOSE'))
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
