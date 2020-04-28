import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:zikir/utils/glob.dart';

class MyHomePage extends StatefulWidget {
  final CounterStorage storage = CounterStorage();

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counters = [0, 0, 0, 0, 0];
  String _buttonStr = "Reset";
  var _zikirs = [
    "Subhanallah",
    "Alhamdulillah",
    "Allahuakbar",
    "Lailahailallah",
  ];
  var _zikirs1 = [
    "سُبْحَانَ ٱللَّٰهِ",
    "ٱلْحَمْدُ لِلَّٰ",
    "اللّٰهُ أَكْبَر",
    "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ",
  ];
  String _curZikr = "Subhanallah";
  String _curZikr1 = "سُبْحَانَ ٱللَّٰهِ";
  var bools = initBool();

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      widget.storage.readSettings().then((String value) {
        bools = stringer(bools, value);
      });

      setState(() {
        _counters[0] = value;
        _initCounters();
      });
    });
  }

  void _gestureHandler(int type) {
    switch (type) {
      case 0:
        if (bools['Tap']) _incrementCounter();
        return null;
      case 1:
        if (bools["Up"]) _incrementCounter();
        return null;
      case 2:
        if (bools["Down"]) _incrementCounter();
        return null;
      case 3:
        if (bools["Hold"]) _reset();
        return null;
    }
    _incrementCounter();
  }

  void _initCounters() {
    if (_counters[0] < 34) {
      _counters[1] = _counters[0];
      _curZikr = _zikirs[0];
      _curZikr1 = _zikirs1[0];
    } else if (_counters[0] < 67) {
      _counters[1] = 33;
      _counters[2] = _counters[0] - 33;
      _curZikr = _zikirs[1];
      _curZikr1 = _zikirs1[1];
    } else if (_counters[0] < 100) {
      _counters[1] = 33;
      _counters[2] = 33;
      _counters[3] = _counters[0] - 66;
      _curZikr = _zikirs[2];
      _curZikr1 = _zikirs1[2];
    } else {
      _counters[1] = 33;
      _counters[2] = 33;
      _counters[3] = 33;
      _counters[4] = _counters[0] - 99;
      _curZikr = _zikirs[3];
      _curZikr1 = _zikirs1[3];
    }
  }

  void _vibrate() {
    Vibration.vibrate(duration: 1000);
  }

  void _setCounters() {
    if (_counters[0] < 34) {
      _counters[1] = _counters[0];
      _curZikr = _zikirs[0];
      _curZikr1 = _zikirs1[0];
    } else if (_counters[0] < 67) {
      _counters[2] = _counters[0] - 33;
      _curZikr = _zikirs[1];
      _curZikr1 = _zikirs1[1];

      print(_zikirs.toString());
    } else if (_counters[0] < 100) {
      _counters[3] = _counters[0] - 66;
      _curZikr = _zikirs[2];
      _curZikr1 = _zikirs1[2];
    } else {
      _counters[4] = _counters[0] - 99;
      _curZikr = _zikirs[3];
      _curZikr1 = _zikirs1[3];
    }
    if (_counters[0] == 33 ||
        _counters[0] == 66 ||
        _counters[0] == 99 ||
        _counters[0] == 199) _vibrate();
        //TODO: Play sound
  }

  Future<File> _incrementCounter() {
    // _save(++_counter);
    setState(() {
      _buttonStr = "Reset";
      _counters[0]++;
      _setCounters();
    });
    return widget.storage.writeCounter(_counters[0]);
  }

  void _panEnd(DragEndDetails dragEndDetails) {
    double sensitivity = 1000.0;
    double dy = dragEndDetails.velocity.pixelsPerSecond.dy;
    print(dy);
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
    print("reset");
    setState(() {
      _buttonStr = "Reset";
      _counters = [-1, 0, 0, 0, 0];
    });
    _gestureHandler(-1);
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
              '${_counters[x]}',
              style: TextStyle(fontSize: 35, color: Colors.white),
              maxLines: 1,
            ),
          )),
    );
  }

  Widget _currentZikr(){
    return Center(
      child: AutoSizeText(
        '$_curZikr',
        style: TextStyle(fontSize: 100, color: Colors.white),
        maxLines: 1,
      ),
    );
  }
  Widget _currentZikr1(){
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
    List<Widget> counterWidgets = [
      bools["Subhanallah"] ? _miniCounter(1) : null,
      bools["Alhamdulillah"] ? _miniCounter(2) : null,
      bools["Allahuakbar"] ? _miniCounter(3) : null,
      bools["Lailahailallah"] ? _miniCounter(4) : null,
    ];
    counterWidgets.removeWhere((value) => value == null);

    List<Widget> display = [
      Row(children: counterWidgets),
      Expanded(
          //main counter
          flex: 1,
          child: Container()),
      bools["Current"]?_currentZikr():null,
      bools["Current"]?_currentZikr1():null,

    ];


    display.removeWhere((value) => value == null);
    display.add(Expanded(
      flex: 5,
      //main counter
      child: Center(
        child: Text(
          '${_counters[0]}',
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
    print("Loading");
    try {
      final path = await _localPath;
      final file = new File('$path/settings.txt');

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0

      return "T F F F";
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    print("Loading");
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    print("Saved");

    return file.writeAsString('$counter');
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
