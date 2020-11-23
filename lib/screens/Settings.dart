import 'package:drive_time_tracker/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class Settings extends StatefulWidget {
  static const routeName = "/settings";

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final prefService = PreferencesService();
  int _timeGoal;
  NumberPicker integerNumberPicker;

  @override
  void initState() {
    super.initState();
    _timeGoal = 0;
    prefService.getPreference<int>('goal').then((int hours) {
      setState(() {
        hours = hours ?? 40;
        _timeGoal = hours == 0 ? 40 : hours;
      });
    });
  }

  void persistGoal(int value) {
    prefService.setPreference<int>('goal', value);

    setState(() {
      _timeGoal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _initNumberPicker();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                        leading: Icon(Icons.timer),
                        title: Text(
                            'Drive Time Goal (hours): ${_timeGoal == 0 ? "not set" : _timeGoal}')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          child: Text('Edit Goal'),
                          onPressed: () {
                            _showIntDialog();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _initNumberPicker() {
    integerNumberPicker = new NumberPicker.integer(
      initialValue: _timeGoal == 0 ? 40 : _timeGoal,
      minValue: 1,
      maxValue: 100,
      step: 1,
      onChanged: (value) => setState(() => _timeGoal = value),
    );
  }

  Future _showIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 100,
          step: 1,
          initialIntegerValue: _timeGoal == 0 ? 40 : _timeGoal,
        );
      },
    ).then((num value) {
      if (value != null) {
        persistGoal(value);
      }
    });
  }
}
