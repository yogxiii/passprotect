import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'changemasterpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  SharedPreferences preferences;
  Color selectedColor = Colors.red;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  Color pickedColor;

  void openSharedPreferences() async{
    preferences = await SharedPreferences.getInstance();

    setState(() {
      if(Color(preferences.getInt('primaryColor')) == null)
        selectedColor = Color(0xff31af91);
      else
        selectedColor = Color(preferences.getInt('primaryColor'));
    });
  }

  @override
  void initState() {
    openSharedPreferences();
    super.initState();
  }

  void changeColor(Color color)
  {
    preferences.setInt('primaryColor', color.value);
    DynamicTheme.of(context).setThemeData(
      ThemeData().copyWith(
        primaryColor: color
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Padding(padding: EdgeInsets.all(16.0),
          child: Container(
            margin: EdgeInsets.only(top: size.height*0.04),
            child: Text(
              'Settings',
              style: TextStyle(
                  fontSize: 34,
                  fontFamily: 'title',
                  fontWeight: FontWeight.w900),
            ),
          ),),

          InkWell(
            child: ListTile(
              title: Text('Master Password',style: TextStyle(
                fontFamily: 'title'
              ),),
              subtitle: Text('Change your master Password',style: TextStyle(
                  fontFamily: 'subtitle'
              ),),
            ),
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangeMasterPassword()));
            },
          ),
          Column(
            children: [
              ListTile(
                title: Text(
                  "Accent Color",
                  style: TextStyle(
                    fontFamily: 'title',
                  ),
                ),
                subtitle: Text(
                  "Change Accent Color",
                  style: TextStyle(
                    fontFamily: 'subtitle',
                  ),
                ),
              ),
             /* MaterialColorPicker(
                onColorChange: (Color color){
                  pickedColor = color;
                  changeColor(color);
                  setState(() {
                    selectedColor = color;
                  });
                },
                circleSize: 60,
                selectedColor: selectedColor,
              )*/
             //TODO : implement darktheme feature
            ],
          )
        ],
      ),
    );
  }
}


