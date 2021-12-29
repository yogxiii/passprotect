import 'package:flutter/material.dart';
import 'package:pass_protect/pages/welcomepage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/homepage.dart';


void main() {
  runApp(PassProtect());
}

class PassProtect extends StatefulWidget {
  @override
  _PassProtectState createState() => _PassProtectState();
}

class _PassProtectState extends State<PassProtect> {

  int firstTime = 0;
  bool loading = true;
  int primaryColorCode;
  Color primaryColor = Color(0xff31af91);

  void checkColor() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    primaryColorCode = preferences.getInt('primaryColor') ?? 0;

    if(primaryColorCode != 0)
      {
        setState(() {
          primaryColor = Color(primaryColorCode);
        });
      }
  }

  Future<void> isUserFirstTime() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    firstTime = preferences.getInt('firstTime') ?? 0;

    final storage = FlutterSecureStorage();
    String masterPassword = await storage.read(key: 'master') ?? '';

    if(preferences.getInt('primaryColor') == null)
      {
        await preferences.setInt('primaryColor', 0);
      }

    if(firstTime == 0 && masterPassword == '')
      {
        await preferences.setInt('firstTime', 1);
        await preferences.setInt('primaryColor', 0);
      }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    checkColor();
    isUserFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkColor();
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        fontFamily: 'title',
        primaryColor: primaryColor,
        //TODO : find accent color for app(secondary color)
        brightness: brightness
      ),

      themedWidgetBuilder: (context, theme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        title: 'PassProtect',
        home:  loading ? Center(
            child: CircularProgressIndicator(),
          ) : firstTime == 0 ? WelcomePage() : HomePage(),
      ),
    );
  }
}

