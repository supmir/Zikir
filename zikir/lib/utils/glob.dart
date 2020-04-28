import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:zikir/utils/data.dart';

stringer(String json) {
  try {
    Data data = jsonDecode(json);
    return data;
  } catch (e) {
    Data data = new Data(
        Interactions({
          'Tap': true, //tap
          'Up': false, //up
          'Down': false, //down
          'Hold': false, //hold
          'Current': true, //curent text
          'Subhanallah': true, //subhanallah
          'Alhamdulillah': true, //alhamdulillah
          'Allahuakbar': true, //allahuakbar
          'Lailahailallah': true, //lailahaillallah
        }),
        Counters());

    var _zikirs1 = [
      "سُبْحَانَ ٱللَّٰهِ",
      "ٱلْحَمْدُ لِلَّٰ",
      "اللّٰهُ أَكْبَر",
      "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ",
    ];
    data.counters.addNew("Subhanallah", _zikirs1[0], 0, 33);
    data.counters.addNew("Alhamdulillah", _zikirs1[0], 0, 33);
    data.counters.addNew("Allahuakbar", _zikirs1[0], 0, 33);
    data.counters.addNew("Lailahailallah", _zikirs1[0], 0, 100);
    return data;
  }
}

initBool() {
  return {
    'Tap': true, //tap
    'Up': false, //up
    'Down': false, //down
    'Hold': false, //hold
    'Current': true, //curent text
    'Subhanallah': true, //subhanallah
    'Alhamdulillah': true, //alhamdulillah
    'Allahuakbar': true, //allahuakbar
    'Lailahailallah': true, //lailahaillallah
  };
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.json');
}

Future<String> readSettings() async {
  print("Loading");
  try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0

    return null;
  }
}

Future<File> writeSettings(Data data) async {
  final file = await _localFile;
  return file.writeAsString(data.toJson().toString());
}
