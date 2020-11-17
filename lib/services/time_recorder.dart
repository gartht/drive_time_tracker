import '../models/DriveRecord.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class TimeRecorderService {
  List<DriveRecord> _drives;

  Future<void> addDrive(DriveRecord addition) async {
    var d = await getDrives();
    d.add(addition);
    await _saveDrives();
  }

  Future<List<DriveRecord>> getDrives() async {
    if (_drives == null) {
      _drives = await _driveRecords;
    }
    return _drives;
  }

  Future<void> deleteAll() async {
    _drives.clear();
    await _saveDrives();
  }

  Future<File> _saveDrives() async {
    var stringData = jsonEncode(_drives);
    var driveFile = await _dataFile;
    return driveFile.writeAsString(stringData, flush: true);
  }

  Future<void> deleteAtIndex(int index) async {
    _drives.removeAt(index);
    await _saveDrives();
  }

  Future<List<DriveRecord>> get _driveRecords async {
    var familyJson = await _drivesJson;
    final parsedJson = jsonDecode(familyJson).cast<Map<String, dynamic>>();

    return parsedJson
        .map<DriveRecord>((json) => DriveRecord.fromJson(json))
        .toList();
  }

  Future<String> get _drivesJson async {
    var memberFile = await _dataFile;
    return await memberFile.readAsString();
  }

  Future<String> get _localStorage async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _dataFile async {
    final path = await _localStorage;
    var fileHandle = File('$path/drives.json');

    if (!fileHandle.existsSync()) {
      return fileHandle.writeAsString('[]');
    }
    return fileHandle;
  }
}
