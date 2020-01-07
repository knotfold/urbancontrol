import 'package:flutter/material.dart';
import 'package:urbancontrol/pages/pages.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
    final _widgetOptions = [
      UrbanList(),
      UrbanList()
    ];
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  @override
  Widget build(BuildContext context) {
    
    


    Widget bottomNavBar() {
      return BottomNavigationBar(
        onTap: onItemTapped,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.featured_play_list) ,title: Text('Urbans')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title:  Text('Config'))
        ],
      );
    }

  
    // TODO: implement build
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.add_box, size: 50,),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddUrban())),
      ),
      bottomNavigationBar: bottomNavBar(),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
