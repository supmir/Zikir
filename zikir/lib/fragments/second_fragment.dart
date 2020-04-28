import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:zikir/utils/glob.dart';

class SettingsPage extends StatefulWidget {
  final SettingsStorage storage = SettingsStorage();

  SettingsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var bools = initBool();

  @override
  void initState() {
    super.initState();
    widget.storage.readSettings().then((String value) {
      setState(() {
        bools = stringer(bools, value);
      });
    });
  }

  Future<File> updateSettings() {
    setState(() {});
    return widget.storage.writeSettings(bools);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (String x in bools.keys) {
      list.add(SwitchListTile(
        value: bools[x],
        onChanged: (val) {
          setState(() {
            bools[x] = !bools[x];
          });
          updateSettings();
        },
        title: Text(x),
      ));
    }

    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: ListView(children: list),
      ),
    );
  }
}

class SettingsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/settings.txt');
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

      return "T F F F T T T T T";
    }
  }

  Future<File> writeSettings(var bools) async {
    final file = await _localFile;

    // Write the file
    print("Saved");
    String s = "";
    for (String x in bools.keys) {
      s += "${bools[x] ? 'T' : 'F'} ";
    }
    return file.writeAsString(s);
  }
}

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(child: SettingsPage());
  }
}
