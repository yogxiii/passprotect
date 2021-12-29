import 'package:flutter/material.dart';
import 'package:pass_protect/constant.dart';
import 'package:pass_protect/model/passwordclass.dart';
import 'package:pass_protect/database/db.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:pass_protect/bloc/passwordbloc.dart';
import 'viewpassword.dart';

import 'addpassword.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  Brightness brightness = Brightness.light;
  HomePage({this.brightness});
}

class _HomePageState extends State<HomePage> {

  int pickedIcon;

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

  final bloc = PasswordBloc();

  @override
  void dispose(){
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    void changeBrightness() {
      DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark);
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PassProtect',
                    style: TextStyle(
                        fontFamily: 'title',
                        fontSize: 34.0,
                        fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 26.0,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                      })
                ],
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Password>>(
              stream: bloc.passwords,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Password password = snapshot.data[index];
                        int i = 0;
                        i = iconNames.indexOf(password.icon);
                        Color color = hexToColor(password.color);
                        return Dismissible(
                          key: ObjectKey(password.id),
                          onDismissed: (direction) {
                            var item = password;
                            //To delete
                            DBProvider.db.deletePassword(item.id);
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                            //To show a snackbar with the UNDO button
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Password deleted"),
                                action: SnackBarAction(
                                    label: "UNDO",
                                    onPressed: () {
                                      DBProvider.db.newPassword(item);
                                      setState(() {
                                        snapshot.data.insert(index, item);
                                      });
                                    })));
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ViewPassword(
                                            password: password,
                                          )));
                            },
                            child: ListTile(
                              title: Text(
                                password.appName,
                                style: TextStyle(
                                  fontFamily: 'Title',
                                ),
                              ),
                              leading: Container(
                                  height: 48,
                                  width: 48,
                                  child: CircleAvatar(
                                      backgroundColor: color, child: icons[i])),
                              subtitle: password.userName != ""
                                  ? Text(
                                password.userName,
                                style: TextStyle(
                                  fontFamily: 'Subtitle',
                                ),
                              )
                                  : Text(
                                "No username specified",
                                style: TextStyle(
                                  fontFamily: 'Subtitle',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Passwords Saved. \nClick \"+\" button to add a password",
                        textAlign: TextAlign.center,
                        // style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPassword(),
            ),
          );
        },
      ),
    );
  }
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 9), radix: 16) + 0xFF000000);
  }
}
