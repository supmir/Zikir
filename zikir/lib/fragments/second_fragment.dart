import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:zikir/utils/data.dart';
import 'package:zikir/utils/glob.dart';

class SettingsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<String> readSettings() async {
    print("Loading settings");
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      print("Settings loaded");

      print(contents);
      return contents;
    } catch (e) {
      // If encountering an error, return 0

      return null;
    }
  }

  Future<File> writeSettings(Data data) async {
    final file = await _localFile;
    try {
      String str = jsonEncode(data);
      // Write the file
      print("Saving...");
      print(str);
      return file.writeAsString(str);
    } catch (e) {
      return file.writeAsString("");
    }
  }
}

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Center(child: SettingsPage());
  }
}

class SettingsPage extends StatefulWidget {
  final SettingsStorage storage = SettingsStorage();

  SettingsPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Data data = stringer(null);
  String resetText = "Reset application";
  @override
  void initState() {
    super.initState();
    widget.storage.readSettings().then((String value) {
      setState(() {
        data = stringer(value);
      });
    });
  }

  Future<File> updateSettings() {
    setState(() {});
    return widget.storage.writeSettings(data);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page1 = [];
    List<Widget> page2 = [];
    List<Widget> page3 = [];
    for (String x in data.interactions.bools.keys) {
      page1.add(Card(
        child: SwitchListTile(
          value: data.interactions.bools[x],
          onChanged: (val) {
            setState(() {
              data.interactions.switchSomething(x);
            });
            // updateSettings();
          },
          title: Text(x),
        ),
      ));
    }

    for (String x in data.counters.counterList.keys) {
      Counter temp = data.counters.counterList[x];
      page2.add(Card(
        child: ListTile(
          title: Text('$x'),
          subtitle: Text('${temp.sentence}\nMaximum value: ${temp.maxValue}'),
          trailing: Icon(Icons.more_vert),
          isThreeLine: true,
        ),
      ));
    }
    page2.add(Card(
      child: ListTile(
        title: Icon(Icons.add_circle),
      ),
    ));
    page3.add(Card(
      child: ListTile(
        title: Center(child: Text("Made by: Amir Iskandar")),
      ),
    ));
    page3.add(Card(
      child: ListTile(
        title: Center(child: Text(resetText)),
        onTap: () {
          setState(
            () {
              resetText = "Press and hold to reset";
            },
          );
        },
        onLongPress: resetApp,
      ),
    ));

    return TabBarView(
      children: [
        Center(
          child: ListView(children: page1),
        ),
        Center(
          child: ListView(children: page2),
        ),
        Center(
          child: ListView(children: page3),
        ),
      ],
    );
  }

  resetApp() {
    widget.storage.writeSettings(null);
    return new SecondFragment();
  }
}
