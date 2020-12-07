import 'package:drive_time_tracker/models/Weather.dart';
import 'package:drive_time_tracker/services/weather_service.dart';
import 'package:drive_time_tracker/services/time_recorder.dart';
import 'package:flutter/material.dart';
import '../models/DriveRecord.dart';
import '../screens/Settings.dart';
import '../screens/DriveList.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:drive_time_tracker/services/preferences_service.dart';

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
  double _percentComplete;
  Weather _weather;

  TimeRecorderService svc = TimeRecorderService();
  PreferencesService psvc = PreferencesService();
  WeatherService wsvc = WeatherService();

  void getWeather() async {
    _weather = await wsvc.getWeatherData();
  }

  @override
  void initState() {
    int _driveMinutes = 0;
    int _goalMinutes = 1;
    _percentComplete = 0;
    Future f1 = svc.getDrives().then((List<DriveRecord> drives) {
      for (var d in drives) {
        _driveMinutes += d.durationInMinutes();
      }
    });
    Future f2 = psvc.getPreference<int>('goal').then((int goal) {
      goal = goal ?? 1;
      _goalMinutes = goal > 0 ? goal : 1;
    });
    super.initState();
    var futures = <Future>[];
    futures.add(f1);
    futures.add(f2);
    Future.wait(futures).then((List<dynamic> l) {
      setState(() {
        _percentComplete = _driveMinutes / _goalMinutes;
      });
    });
  }

  Future<void> _saveDrive() async {
    var drive = new DriveRecord(_driveStart, _driveEnd, _weather);
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
          percent: _percentComplete,
          center: Text(
            '% Complete: ${_percentComplete * 100}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                getWeather();
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
