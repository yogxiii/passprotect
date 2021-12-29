import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pass_protect/constant.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import 'package:password_strength/password_strength.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:pass_protect/model/passwordclass.dart';
import 'package:pass_protect/database/db.dart';

import 'homepage.dart';

class AddPassword extends StatefulWidget {
  @override
  _AddPasswordState createState() => _AddPasswordState();
}

class _AddPasswordState extends State<AddPassword> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController appNameController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  String keyString = '';
  String encryptedString = '';
  String decryptedString = '';
  String masterPasswordString = '';

  Future<Null> getMasterPassword() async {
    final storage = FlutterSecureStorage();
    String masterPassword = await storage.read(key: 'master') ?? '';
    masterPasswordString = masterPassword;
  }

  void authenticate() async {
    try {
      bool isAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to add new password');

      if (isAuthenticate == false) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        //TODO ----------------handle exception here
      }
    }
  }

  Color pickedColor;
  int pickedIcon;
  encrypt.Encrypted encrypted;

  List<Icon> icons = [
    Icon(Icons.account_circle, size: 28, color: Colors.white),
    Icon(Icons.add, size: 28, color: Colors.white),
    Icon(Icons.access_alarms, size: 28, color: Colors.white),
    Icon(Icons.ac_unit, size: 28, color: Colors.white),
    Icon(Icons.accessible, size: 28, color: Colors.white),
    Icon(Icons.account_balance, size: 28, color: Colors.white),
    Icon(Icons.add_circle_outline, size: 28, color: Colors.white),
    Icon(Icons.airline_seat_individual_suite, size: 28, color: Colors.white),
    Icon(Icons.arrow_drop_down_circle, size: 28, color: Colors.white),
    Icon(Icons.assessment, size: 28, color: Colors.white),
  ];

  List<String> iconNames = [
    "Icon 1",
    "Icon 2",
    "Icon 3",
    "Icon 4",
    "Icon 5",
    "Icon 6",
    "Icon 7",
    "Icon 8",
    "Icon 9",
    "Icon 10",
  ];

  List<Color> colors = [
    Colors.red,
    Color(0xffcf5a3b),
    Color(0xffba673e),
    Color(0xffa87341),
    Color(0xffa07842),
    Color(0xff8b8646),
    Color(0xff808d47),
    Color(0xff6d994a),
    Color(0xff5ea34d),
    Color(0xff58a64e),
    Colors.green
  ];

  double passwordStrength = 0.0;
  Color passwordStrengthBarColor = Colors.red;
  bool obscureText = true;
  String showPass = 'Show Password';
  IconData visibleIcon = Icons.visibility_off;

  @override
  void initState() {
    pickedColor = kColor;
    pickedIcon = 0;
    getMasterPassword();
    super.initState();
  }

  void checkPasswordStrength(String password)
  {
    setState(() {
      passwordStrength = estimatePasswordStrength(password);
      Color passwordStrengthBarColor = Colors.red;
      if (passwordStrength < 0.4) {
        passwordStrengthBarColor = Colors.red;
      } else if (passwordStrength > 0.4 && passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.deepOrangeAccent;
      } else if (passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.orange;
      } else if (passwordStrength > 0.7 || passwordStrength == 0.7) {
        passwordStrengthBarColor = kColor;
      }
      setState(() {
        this.passwordStrengthBarColor = passwordStrengthBarColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
                  'Add Password',
                  style: TextStyle(
                      fontFamily: 'title',
                      fontSize: 34,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Form(key: _formKey,
                child: Column(
              children: [
                  Padding(padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'App Name',
                      labelStyle: TextStyle(fontSize: 18,fontFamily: 'subtitle'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)
                      ),
                      prefixIcon: Icon(Icons.app_registration),
                    ),
                    cursorColor: kColor,
                    controller: appNameController,
                    validator: (String value){
                      if(value.isEmpty)
                        return 'Please enter the App name';
                      else
                        return null;
                    },
                  ),),

                Padding(padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 18,fontFamily: 'subtitle'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    cursorColor: kColor,
                    controller: userNameController,
//                    validator: (String value){
//                      if(value.isNotEmpty)
//                        return 'Please enter the App name';
//                      else
//                        return null;
//                    },
                  ),),

                Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 18,fontFamily: 'subtitle'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(icon: Icon(visibleIcon),
                          onPressed: (){
                            setState(() {
                              obscureText = !obscureText;
                              if(obscureText)
                                visibleIcon = Icons.visibility ;
                              else
                                visibleIcon = Icons.visibility_off;
                            });
                          })
                    ),
                    onChanged: (password){
                      checkPasswordStrength(password);
                    },
                    obscureText: obscureText,
                    cursorColor: kColor,
                    controller: passwordController,
                    validator: (String value){
                      if(value.isEmpty)
                        return 'Please enter the Password';
                      else
                        return null;
                    },

                  ),),
                
                Padding(padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){
                      //TODO Create generate password class/method
                    }, child: Text('Generate')),

//                    TextButton(onPressed: (){
//                      setState(() {
//                        obscureText = !obscureText;
//                        if(obscureText)
//                          showPass = 'Hide Password';
//                        else
//                          showPass = 'Show Password';
//                      });
//                    },
//                        child: Text(showPass)),

                    TextButton(onPressed: (){
                      Clipboard.setData(ClipboardData(
                        text: passwordController.text
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied'),duration: Duration(seconds: 2),)
                      );
                    },
                        child: Text('Copy'))
                  ],
                ),),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 10,
                      width: passwordStrength == 0
                          ? 5
                          : MediaQuery.of(context).size.width *
                          passwordStrength,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: passwordStrengthBarColor,
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: Text('Pick an Icon',
                    style: TextStyle(fontFamily: 'title',
                    fontSize: 26,
                    fontWeight: FontWeight.w900),),),

                    Padding(padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                    child: Material(
                      shape: CircleBorder(),
                      elevation: 4.0,
                      child: CircleAvatar(
                        backgroundColor: pickedColor,
                        radius: 22,
                        child: icons[pickedIcon],
                      ),
                    ),)
                  ],
                ),),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0, 24, 10),
                  child: GridView.count(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 5,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.3,
                      children: List.generate(icons.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              pickedIcon = index;
                            });
                          },
                          child: Material(
                              elevation: 3.0,
                              color: pickedColor,
                              shape: CircleBorder(),
                              child: icons[index]),
                        );
                      })),
                ),

                Padding(padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                        child: Text('Pick an Color',
                          style: TextStyle(fontFamily: 'title',
                              fontSize: 26,
                              fontWeight: FontWeight.w900),),),

                      InkWell(onTap: (){
                        _openColorPicker();
                      },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                          child: Material(
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: CircleAvatar(
                              backgroundColor: pickedColor,
                              radius: 22,
                            ),
                          ),
                        ),)
                    ],
                  ),),
              ],
            )),


            Padding(padding: EdgeInsets.fromLTRB(16,2,16,10),
            child: Center(
              child: SizedBox(
                height: 60,
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
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      encryptPass(passwordController.text);
                      Password password = new Password(
                        appName: appNameController.text,
                        password: encryptedString,
                        color: '#' + pickedColor.value.toRadixString(16),
                        icon: iconNames[pickedIcon],
                        userName: userNameController.text
                      );
                      DBProvider.db.newPassword(password);
                      Navigator.pushAndRemoveUntil(context, 
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                              (Route<dynamic> route) => false);
                    }
                    else{
                      print("Invalid Form");
                    }
                  },
                ),
              )
            ),)
          ],
        ),
      ),
    );
  }

  _openColorPicker() async {
    Color _tempShadeColor = pickedColor;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Color picker"),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  pickedColor = _tempShadeColor;
                });
              },
            ),
          ],
          content: MaterialColorPicker(
            allowShades: true,
            selectedColor: _tempShadeColor,
            onColorChange: (color) => setState(() => _tempShadeColor = color),
            onMainColorChange: (color) =>
                setState(() => _tempShadeColor = color),
          ),
        );
      },
    );
  }

  encryptPass(String text) {
    keyString = masterPasswordString;
    if (keyString.length < 32) {
      int count = 32 - keyString.length;
      for (var i = 0; i < count; i++) {
        keyString += ".";
      }
    }
    final key = encrypt.Key.fromUtf8(keyString);
    final plainText = text;
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final e = encrypter.encrypt(plainText, iv: iv);
    encryptedString = e.base64.toString();
  }

}


