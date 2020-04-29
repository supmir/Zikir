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
  final _formKey = GlobalKey<FormState>();
  Counter counter = new Counter.def();

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

  buildPage1() {
    List<Widget> temp = [];
    for (String x in data.interactions.bools.keys) {
      temp.add(Card(
        child: SwitchListTile(
          value: data.interactions.bools[x],
          onChanged: (val) {
            setState(() {
              data.interactions.switchSomething(x);
            });
            updateSettings();
          },
          title: Text(x),
        ),
      ));
    }
    return temp;
  }

  buildPage2() {
    List<Widget> temp1 = [];

    for (String key in data.counters.counterList.keys) {
      Counter temp = data.counters.counterList[key];
      temp1.add(Card(
        child: ListTile(
          title: Text('$key'),
          subtitle: Text('${temp.sentence}\nMaximum value: ${temp.maxValue}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Checkbox(value: temp.active, onChanged: (value){
                setState(() {
                  // temp.changeActive();
                  data.counters.changeActive(key);
                });
                updateSettings();
              }),
              PopupMenuButton(
                onSelected: (result) {
                  switch (result) {
                    case 1:
                      break;
                    case 2:
                      setState(() {
                        data.counters.removeByString(key);
                      });
                      updateSettings();
                      break;
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Edit"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Delete"),
                    value: 2,
                  ),
                ],
              ),
            ],
          ),
          // trailing: Container,
          isThreeLine: true,
          // onLongPress: () {
          //   setState(() {
          //     data.counters.removeByString(x);
          //   });
          //   updateSettings();
          // },
        ),
      ));
    }
    temp1.add(Card(
      child: ListTile(
        title: Icon(Icons.add_circle),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return buildAlertDialog(context);
              });
        },
      ),
    ));
    return temp1;
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.black38,
              ),
            ),
          ),
          buildForm(context),
        ],
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(0),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a name";
                  }
                },
                onSaved: (val) {
                  counter.setName(val);
                },
              )),
          Padding(
              padding: EdgeInsets.all(0),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Subtitle"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a subtitle";
                  }
                },
                onSaved: (val) {
                  counter.setSentence(val);
                },
              )),
          Padding(
              padding: EdgeInsets.all(0),
              child: TextFormField(
                decoration: const InputDecoration(hintText: "Maximum Value"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "false";
                  }
                  return int.tryParse(value) == null
                      ? "Please only enter number"
                      : null;
                },
                onSaved: (val) {
                  counter.setMaxValue(int.parse(val));
                },
              )),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: RaisedButton(
              child: Text("Save"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    data.counters.addNewByCounter(counter);
                    counter = new Counter.def();
                    updateSettings();
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  buildPage3() {
    List<Widget> temp = [];
    temp.add(Card(
      child: ListTile(
        title: Center(child: Text("Made by: Amir Iskandar")),
      ),
    ));
    temp.add(Card(
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

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page1 = buildPage1();
    List<Widget> page2 = buildPage2();
    List<Widget> page3 = buildPage3();

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
    initState();
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Edit', icon: Icons.directions_bus),
  const Choice(title: 'Disable', icon: Icons.directions_railway),
  const Choice(title: 'Delete', icon: Icons.directions_walk),
];
