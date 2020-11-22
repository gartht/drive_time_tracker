import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  static const routeName = "/settings";

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _timeGoal;
  NumberPicker integerNumberPicker;

  @override
  void initState() {
    // TODO: pull this from preferences
    super.initState();
    _timeGoal = 0;
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        _timeGoal = (prefs.getInt('goal') ?? 40);
      });
    });
  }

  Future<void> persistGoal(int value) async {
    var prefs = await _prefs;
    prefs.setInt('goal', value);
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
