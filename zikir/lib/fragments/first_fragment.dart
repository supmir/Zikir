import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:zikir/utils/data.dart';
import 'package:zikir/utils/glob.dart';

class MyHomePage extends StatefulWidget {
  final CounterStorage storage = CounterStorage();

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _mainCounter = 0;
  String _buttonStr = "Reset";
  String _curZikr = "";
  String _curZikr1 = "";
  Data data = stringer(null);

  @override
  void initState() {
    //print("InitState");
    super.initState();
    widget.storage.readSettings().then((String value) {
      setState(() {
        //print("Initialising data");
        data = stringer(value);
        //print(data.getJsonString());
        _mainCounter = data.counters.getTotal();
        _updateCounters();
      });
    });
    // widget.storage.readCounter().then((int value) {
    //   setState(() {
    //     _mainCounter = value;
    //     _updateCounters();
    //   });
    // });
  }

  void _gestureHandler(int type) {
    switch (type) {
      case 0:
        if (data.interactions.bools['Tap']) _incrementCounter();
        return null;
      case 1:
        if (data.interactions.bools["Up"]) _incrementCounter();
        return null;
      case 2:
        if (data.interactions.bools["Down"]) _incrementCounter();
        return null;
      case 3:
        if (data.interactions.bools["Hold"]) _reset();
        return null;
    }
    _incrementCounter();
  }

  void _vibrate() {
    Vibration.vibrate(duration: 1000);
  }

  void _updateCounters() {
    //print("\n\n\n\n\n\n\nUpdating Counters");
    Counter current = data.counters.update(_mainCounter);
    
    print(current.name);
    _curZikr = current.name;
    _curZikr1 = current.sentence;
    //TODO: Play sound
  }

  Future<File> _incrementCounter() {
    // _save(++_counter);
    setState(() {
      _buttonStr = "Reset";
      _mainCounter++;
      _updateCounters();
    });
    return widget.storage.writeSettings(data);
  }

  void _panEnd(DragEndDetails dragEndDetails) {
    double sensitivity = 1000.0;
    double dy = dragEndDetails.velocity.pixelsPerSecond.dy;
    if (dy < -sensitivity) {
      print("Up flick detected");
      _gestureHandler(1);
    }
    if (dy > sensitivity) {
      print("Down flick detected");
      _gestureHandler(2);
    }
  }

  void _reset() {
    setState(() {
      _buttonStr = "Reset";
      _mainCounter = 0;
      data.counters.update(_mainCounter);
      widget.storage.writeSettings(data);
      //print("\n\n\nreset");

      _updateCounters();
    });
  }

  Widget _miniCounter(int x) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(3.0),
          // decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black)),
          child: Center(
            child: AutoSizeText(
              '$x',
              style: TextStyle(fontSize: 35, color: Colors.white),
              maxLines: 1,
            ),
          )),
    );
  }

  Widget _currentZikr() {
    return Center(
      child: AutoSizeText(
        '$_curZikr',
        style: TextStyle(fontSize: 100, color: Colors.white),
        maxLines: 1,
      ),
    );
  }

  Widget _currentZikr1() {
    return Center(
      child: AutoSizeText(
        '$_curZikr1',
        style: TextStyle(fontSize: 150, color: Colors.white),
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> counterWidgets = [];

    for (String x in data.counters.counterList.keys) {
      counterWidgets.add(_miniCounter(data.counters.counterList[x].value));
    }

    List<Widget> display = [
      Row(children: counterWidgets),
      Expanded(
          //main counter
          flex: 1,
          child: Container()),
      data.interactions.bools["Current"] ? _currentZikr() : null,
      data.interactions.bools["Current"] ? _currentZikr1() : null,
    ];

    display.removeWhere((value) => value == null);
    display.add(Expanded(
      flex: 5,
      //main counter
      child: Center(
        child: Text(
          '${_mainCounter}',
          style: TextStyle(fontSize: 100, color: Colors.white),
        ),
      ),
    ));

    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            _gestureHandler(0);
          },
          onPanEnd: _panEnd,
          onLongPress: () {
            _gestureHandler(3);
          },
          child: Stack(children: <Widget>[
            Column(
              //Background
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Column(
              //Display
              children: display,
            ),
            Column(
              //Cover and Buttons
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  color: Colors.lime,
                  child: FlatButton(
                    child: Text("$_buttonStr"),
                    onPressed: () {
                      setState(() {
                        _buttonStr = "Press and hold to reset";
                      });
                    },
                    onLongPress: _reset,
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class CounterStorage {
  Future<String> readSettings() async {
    //print("Loading settings file");
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      //print(contents);

      return contents;
    } catch (e) {
      // If encountering an error, return 0

      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<File> writeSettings(Data data) async {
    final file = await _localFile;
    try {
      String str = jsonEncode(data);
      // Write the file
      //print("Saving...");
      //print(str);
      return file.writeAsString(str);
    } catch (e) {
      return file.writeAsString("");
    }
  }
}

class FirstFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: MyHomePage(),
    );
  }
}
