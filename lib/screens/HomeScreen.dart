import 'package:drive_time_tracker/services/time_recorder.dart';
import 'package:flutter/material.dart';
import '../models/DriveRecord.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

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
    if (running) {
      widgets.add(Text("Tracking Drive Time",
          style: TextStyle(
              color: Colors.green[500],
              fontSize: 20,
              fontWeight: FontWeight.bold)));
    }

    widgets.add(Center(
      child: FlatButton(
        child: Text(running ? runningText : notRunningText),
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
    ));

    return widgets;
  }

  Function get _buttonAction {
    if (running) return null;
    return () {
      Navigator.pushNamed(context, "/driveList");
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _buttonAction)],
      ),
      body: Column(children: [
        SizedBox(
          height: 20.0,
        ),
        ..._layout,
      ]),
    );
  }
}
