import 'package:eraffle/Screen/History/HistoryScreen.dart';
import 'package:eraffle/Screen/Profile/ProfileScreen.dart';
import 'package:eraffle/Screen/Raffle/RaffleScreen.dart';
import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Tabs> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    RaffleScreen(),
    HistoryScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purpleAccent,
        selectedFontSize: 15,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            label: "History",
          ),
        ],
      ),
    );
  }
}
