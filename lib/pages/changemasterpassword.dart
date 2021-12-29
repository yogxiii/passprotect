import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'homepage.dart';
import 'package:pass_protect/model/passwordclass.dart';
import 'package:pass_protect/database/db.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../constant.dart';

class ChangeMasterPassword extends StatefulWidget {
  @override
  _ChangeMasterPasswordState createState() => _ChangeMasterPasswordState();
}

class _ChangeMasterPasswordState extends State<ChangeMasterPassword> {

  TextEditingController masterPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isStrong = false;
  String _masterPass;
  bool decrypt = false;
  String decrypted = "";
  String encryptedString = "";

  Future<Null> getMasterPassword() async {
    final storage = FlutterSecureStorage();
    String masterPassword = await storage.read(key: 'master') ?? '';
    _masterPass =  masterPassword;
  }

  void clearText1(){
    masterPasswordController.clear();
  }
  void clearText2()
  {
    confirmPasswordController.clear();
  }
  void clearText3(){
    newPasswordController.clear();
  }

  void setMasterPassword(String pass) async {

    final storage = FlutterSecureStorage();
    await storage.write(key: 'master', value: pass);
  }

  bool checkMasterPassword(String pass)
  {
    if(_masterPass == pass)
      return true;
    return false;
  }

  final LocalAuthentication auth = LocalAuthentication();

  void authenticate() async {
    final isDeviceSupported = await auth.isDeviceSupported();
    if (isDeviceSupported) {
      bool isAuthenticated = await auth.authenticate(
          localizedReason: "Please Authenticate", stickyAuth: true);
      if (!isAuthenticated) Navigator.pop(context);
    } else
      print("----------------error-----------------");
  }

  void notStrongPasswordAlert()
  {
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
  }

  void passwordNotMatchAlert(){
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

  void incorrectOldPasswordAlert(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(fontFamily: 'title'),
            ),
            content: Text(
              "Incorrect Old Password",
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

   getAllPasswordFromDB() async
  {
    List<Password> resultList = await DBProvider.db.getAllPassword();
    await DBProvider.db.deleteAllPassword();
//    List<int> idToBeDeleted;
//    int idx = 0;
////    for(var i in resultList)
////      {
////        idToBeDeleted[idx] = i.id;
////        idx++;
////      }
    for(var i in resultList){
      decryptPass(i.password, _masterPass);
      encryptPass(decrypted, newPasswordController.text);
      Password password = new Password(
        appName: i.appName,
        userName: i.userName,
        color: i.color,
        icon: i.icon,
        password: encryptedString
      );
      DBProvider.db.newPassword(password);
      print(i.password);
    print(decrypted);
    }

//    for(var i in idToBeDeleted)
//      {
//        await DBProvider.db.deletePassword(i);
//      }
//    resultList.clear();
//    idToBeDeleted.clear();
  }

  encryptPass(String text, String newMasterPass) {
    String keyString = newMasterPass;
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

  void decryptPass(String encryptedPass, String masterPass) {
    String keyString = masterPass;
    if (keyString.length < 32) {
      int count = 32 - keyString.length;
      for (var i = 0; i < count; i++) {
        keyString += ".";
      }
    }

    final iv = encrypt.IV.fromLength(16);
    final key = encrypt.Key.fromUtf8(keyString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final d = encrypter.decrypt64(encryptedPass, iv: iv);
    setState(() {
      decrypted = d;
      decrypt = true;
    });

//    try {
//      final encrypter = encrypt.Encrypter(encrypt.AES(key));
//      final d = encrypter.decrypt64(encryptedPass, iv: iv);
//      setState(() {
//        decrypted = d;
//        decrypt = true;
//      });
//    } catch (exception) {
//      showDialog(
//          context: context,
//          builder: (context) {
//            return AlertDialog(
//              title: Text(
//                'Something is not right!!',
//                style: TextStyle(fontFamily: 'title'),
//              ),
//              content: Text(
//                "Try Later",
//                style: TextStyle(fontFamily: "subtitle"),
//              ),
//              actions: [
//                TextButton(
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: Text('CLOSE'))
//              ],
//            );
//          });
//    }
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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  'Choose your password carefully, if you forget master password it cannot be retrieved',
                  style: TextStyle(fontFamily: 'subtitle', fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  obscureText: true,
                  maxLength: 16,
                  cursorColor: kColor,
                  decoration: InputDecoration(
                    labelStyle:
                    TextStyle(fontFamily: 'subtitle', fontSize: 18.0),
                    labelText: 'Enter old Password',
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
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  obscureText: true,
                  maxLength: 16,
                  cursorColor: kColor,
                  decoration: InputDecoration(
                    labelStyle:
                    TextStyle(fontFamily: 'subtitle', fontSize: 18.0),
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: clearText3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  controller: newPasswordController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                padding: const EdgeInsets.fromLTRB(16,8,16,8),
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
                    controller: newPasswordController),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 2, 16, 12),
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
                      onPressed: () async {
                        if( masterPasswordController.text.isNotEmpty &&
                            checkMasterPassword(masterPasswordController.text)){
                          if (!isStrong) {
                            notStrongPasswordAlert();
                          } else if (newPasswordController.text ==
                              confirmPasswordController.text) {
//                            setMasterPassword(
//                                newPasswordController.text.trim());
                            await getAllPasswordFromDB();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            passwordNotMatchAlert();
                          }
                        } else {
                            incorrectOldPasswordAlert();
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
