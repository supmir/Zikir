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
    new DrawerItem("Counter", Icons.rss_feed),
    new DrawerItem("Settings", Icons.local_pizza),
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
    setState(() => _selectedDrawerIndex = index);
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

    return new Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Zikir"),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text('Zikir',style: TextStyle(fontSize: 50),),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            new Column(children: drawerOptions),
            // ListTile(
            //   title:Text("Counter"),
            //   onTap: _onSelectItem(0),
            // )
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
