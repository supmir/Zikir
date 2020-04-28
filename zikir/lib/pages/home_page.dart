import 'package:zikir/fragments/first_fragment.dart';
import 'package:zikir/fragments/second_fragment.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Counter", Icons.brightness_3),
    new DrawerItem("Settings", Icons.settings),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  FirstFragment firstFragment = new FirstFragment();
  SecondFragment secondFragment = new SecondFragment();

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return firstFragment;
      case 1:
        return secondFragment;
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
      if (index == 1) {}
    });
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: buildAppBar(_selectedDrawerIndex),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Zikir',
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              new Column(children: drawerOptions),
            ],
          ),
        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  AppBar buildAppBar(int _selectedDrawerIndex) {
    if (_selectedDrawerIndex == 1) {
      return AppBar(
        title: Text("Zikir"),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.gesture)),
            Tab(icon: Icon(Icons.control_point_duplicate)),
            Tab(icon: Icon(Icons.person)),
          ]
        ),
      );
    }
    return AppBar(
      title: Text("Zikir"),
    );
  }
}
