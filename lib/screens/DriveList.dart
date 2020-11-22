import 'package:drive_time_tracker/models/DriveRecord.dart';
import 'package:drive_time_tracker/services/time_recorder.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DriveList extends StatefulWidget {
  static const routeName = "/driveList";
  final svc = TimeRecorderService();

  @override
  _DriveListState createState() => _DriveListState();
}

class _DriveListState extends State<DriveList> {
  Future<List<DriveRecord>> _getDriveRecords() async {
    List<DriveRecord> drives = await widget.svc.getDrives();
    return drives;
  }

  List<DriveRecord> _drs = List<DriveRecord>();

  void _deleteAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: 'Delete Records?',
      desc: 'This will delete all records. This action cannot be undone.',
      buttons: [
        DialogButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
          width: 80.0,
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.symmetric(horizontal: 3),
        ),
        DialogButton(
          child: Text('Delete'),
          onPressed: () {
            print('delete all');
            widget.svc.deleteAll();
            Navigator.pop(context);
          },
          width: 80.0,
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.symmetric(horizontal: 3),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    _getDriveRecords().then((List<DriveRecord> rows) {
      setState(() {
        _drs = rows;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Past Drives"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAlert,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _drs.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.black,
                onPressed: () {
                  print('delete requested for index $index');
                  widget.svc.deleteAtIndex(index);
                },
              ),
              tileColor: Colors.green[200],
              title: Text(_drs[index].date()),
              isThreeLine: true,
              subtitle: Text(
                'Start: ${_drs[index].startTime()}\nEnd: ${_drs[index].endTime()}\nDuration: ${_drs[index].duration()}',
                style: TextStyle(color: Colors.black),
              ),
              dense: true,
            ),
          );
        },
      ),
    );
  }
}
