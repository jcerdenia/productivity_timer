import 'package:flutter/material.dart';
import 'package:productivity_timer/settings.dart';
import 'package:productivity_timer/timer.dart';
import 'package:productivity_timer/timermodel.dart';
import 'package:productivity_timer/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE,
      theme: ThemeData(primarySwatch: Colors.blueGrey,),
      home: TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatelessWidget {
  final CountDownTimer timer = CountDownTimer();
  EdgeInsets defaultPadding() => EdgeInsets.all(5.0);

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = List();
    menuItems.add(PopupMenuItem(value: 'Settings', child: Text('Settings'),));
    timer.startWork();
    return Scaffold(
      appBar: AppBar(
        title: Text(TITLE),
        actions: [ PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => menuItems.toList(),
          onSelected: (s) { if (s == 'Settings') goToSettings(context); },
        )],
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        return Column(children: [
          Row(children: [
            Padding(padding: defaultPadding()),
            Expanded(child: ProductivityButton(
                color: Color(COLOR_PRIMARY),
                text: "Work",
                onPressed: () => timer.startWork()
            )),
            Padding(padding: defaultPadding()),
            Expanded(child: ProductivityButton(
                color: Color(0xff607D8B),
                text: "Short Break",
                onPressed: () => timer.startBreak(true)
            )),
            Padding(padding: defaultPadding()),
            Expanded(child: ProductivityButton(
                color: Color(COLOR_SECONDARY),
                text: "Long Break",
                onPressed: () => timer.startBreak(false)
            )),
            Padding(padding: defaultPadding()),
          ],),
          StreamBuilder(
            initialData: '00:00',
            stream: timer.stream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              TimerModel timer = (snapshot.data == '00:00') ? TimerModel('00:00', 1) : snapshot.data;
              return Expanded(child: CircularPercentIndicator(
                radius: availableWidth / 2,
                lineWidth: 10.0,
                percent: timer.percent,
                center: Text(timer.time, style: Theme.of(context).textTheme.headline4),
                progressColor: Color(COLOR_PRIMARY),
              ));
            }
          ),
          Row(children: [
            Padding(padding: defaultPadding()),
            Expanded(child: ProductivityButton(
                color: Color(0xff212121),
                text: "Stop",
                onPressed: () => timer.stopTimer()
            )),
            Padding(padding: defaultPadding()),
            Expanded(child: ProductivityButton(
                color: Color(COLOR_PRIMARY),
                text: "Start",
                onPressed: () => timer.startTimer()
            )),
            Padding(padding: defaultPadding()),
          ])
        ]);
      })
    );
  }

  void goToSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }
}