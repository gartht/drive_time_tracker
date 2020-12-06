import 'package:drive_time_tracker/models/Weather.dart';

class DriveRecord {
  DateTime _start;
  DateTime _end;
  Weather _weather;

  DriveRecord(this._start, this._end, this._weather);

  Map<String, dynamic> toJson() {
    return {
      'start': this._start.toIso8601String(),
      'end': this._end.toIso8601String(),
      'weather': this._weather.toJson(),
    };
  }

  factory DriveRecord.fromJson(Map<String, dynamic> json) {
    var start = DateTime.parse(json['start']);
    var end = DateTime.parse(json['end']);
    var weather = Weather.fromJson(json['weather']);
    return DriveRecord(start, end, weather);
  }

  String date() {
    return "${_start.month}/${_start.day}/${_start.year}";
  }

  String startTime() {
    return _getTimeString(_start.hour, _start.minute);
  }

  String endTime() {
    return _getTimeString(_end.hour, _end.minute);
  }

  String _getTimeString(int hour, int minute) {
    String postFix = "am";

    if (hour >= 12) {
      postFix = "pm";
      hour = hour > 12 ? hour - 12 : hour;
    }
    return "${_formatTimeNumber(hour)}:${_formatTimeNumber(minute)}$postFix";
  }

  String _formatTimeNumber(int num) {
    return num < 10 ? '0$num' : '$num';
  }

  int durationInMinutes() {
    var span = _end.difference(_start);
    return span.inMinutes;
  }

  String duration() {
    var span = _end.difference(_start);
    var hours = (span.inMinutes / 60).floor();
    var minutes = span.inMinutes % 60;

    return "${_formatTimeNumber(hours)}:${_formatTimeNumber(minutes)}";
  }
}
