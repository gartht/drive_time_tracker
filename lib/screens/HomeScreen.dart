import 'package:drive_time_tracker/services/time_recorder.dart';
import 'package:flutter/material.dart';
import '../models/DriveRecord.dart';
import '../screens/Settings.dart';
import '../screens/DriveList.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const Color drivingColor = Colors.red;
const Color drivingAccent = Colors.redAccent;
const Color idleColor = Colors.green;
const Color idleAccent = Colors.greenAccent;

class _HomeScreenState extends State<HomeScreen> {
  final String notRunningText = "Start tracking your time.";
  final String runningText = "Finish tracking your time.";
  bool running = false;

  DateTime _driveStart;
  DateTime _driveEnd;

  TimeRecorderService svc = TimeRecorderService();

  Future<void> _saveDrive() async {
    var drive = new DriveRecord(_driveStart, _driveEnd);
    await svc.addDrive(drive);
  }

  List<Widget> get _layout {
    var widgets = List<Widget>();

    widgets.add(
      Text(
        running ? "Tracking Drive Time" : "",
        style: TextStyle(
            color: Colors.green[500],
            fontSize: 30,
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );

    widgets.add(Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: CircularPercentIndicator(
          radius: 200.0,
          lineWidth: 20.0,
          percent: 0.20,
          center: Text('% Complete'),
          progressColor: Colors.lightBlueAccent,
        ),
      ),
    ));

    widgets.add(Expanded(
      flex: 1,
      child: Center(
        child: RaisedButton(
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0),
            side: BorderSide(
              color: running ? drivingAccent : idleAccent,
              width: 2,
            ),
          ),
          color: running ? drivingColor : idleColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              running ? runningText : notRunningText,
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () {
            setState(() {
              if (running) {
                _driveEnd = DateTime.now();
                _saveDrive();
              } else {
                _driveStart = DateTime.now();
              }
              running = !running;
            });
          },
        ),
      ),
    ));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, Settings.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, DriveList.routeName);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._layout,
          ]),
    );
  }
}
