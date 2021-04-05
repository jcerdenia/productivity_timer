import 'package:flutter/material.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const String WORKTIME = 'workTime';
  static const String SHORTBREAK = 'shortBreak';
  static const String LONGBREAK = 'longBreak';

  SharedPreferences prefs;
  TextEditingController txtWork;
  TextEditingController txtShort;
  TextEditingController txtLong;
  TextStyle textStyle = TextStyle(fontSize: 24);

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      childAspectRatio: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: <Widget>[
        Text('Work', style: textStyle),
        empty(),
        empty(),
        SettingButton(Color(COLOR_SECONDARY), '-', -1, WORKTIME, writeSetting),
        defaultTextField(txtWork, WORKTIME),
        SettingButton(Color(COLOR_PRIMARY), '+', 1, WORKTIME, writeSetting),
        Text('Short', style: textStyle),
        empty(),
        empty(),
        SettingButton(Color(COLOR_SECONDARY), '-', -1, SHORTBREAK, writeSetting),
        defaultTextField(txtShort, SHORTBREAK),
        SettingButton(Color(COLOR_PRIMARY), '+', 1, SHORTBREAK, writeSetting),
        Text('Long', style: textStyle),
        empty(),
        empty(),
        SettingButton(Color(COLOR_SECONDARY), '-', -1, LONGBREAK, writeSetting),
        defaultTextField(txtLong, LONGBREAK),
        SettingButton(Color(COLOR_PRIMARY), '+', 1, LONGBREAK, writeSetting),
      ],
      padding: const EdgeInsets.all(20.0),
    ));
  }

  Text empty() => Text('');

  TextField defaultTextField(TextEditingController controller, String key) {
    return TextField(
      style: textStyle,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: (text) => prefs.setInt(key, int.parse(text)),
    );
  }

  readSettings() async { // returns a Future
    prefs = await SharedPreferences.getInstance();
    int workTime = (prefs.getInt(WORKTIME) == null) ? 30 : prefs.getInt(WORKTIME);
    int shortBreak = (prefs.getInt(SHORTBREAK) == null) ? 5 : prefs.getInt(SHORTBREAK);
    int longBreak = (prefs.getInt(LONGBREAK) == null) ? 20 : prefs.getInt(LONGBREAK);

    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void writeSetting(String key, int value) {
    int defTime;
    int maxTime;
    TextEditingController controller;
    if (key == WORKTIME) {
      defTime = 30;
      maxTime = 180;
      controller = txtWork;
    } else if (key == SHORTBREAK) {
      defTime = 5;
      maxTime = 120;
      controller = txtShort;
    } else if (key == LONGBREAK) {
      defTime = 20;
      maxTime = 180;
      controller = txtLong;
    }
    
    int savedTime = prefs.getInt(key);
    int time = (savedTime != null) ? savedTime : defTime;
    time += value;
    if (time >=1 && time <= maxTime) {
      prefs.setInt(key, time);
      setState(() {
        controller.text = time.toString();
      });
    }
  }
}