import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:game/src/models/data_api_model.dart';
import 'package:game/src/provider/data_cod19.dart';
import 'package:game/src/ui/pages/inicio.dart';
import 'package:game/src/ui/pages/lista_paises.dart';
import 'package:game/src/ui/pages/map_cod19.dart';
import 'package:game/src/utils/network/Utils.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    ListaPaises(),
    Inicio(),
    MapCod19(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[700],
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Lista')),
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Inicio')),
              BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapa')),
            ]),
        body: IndexedStack(
          index: _currentIndex,
          children: _children
        ));
  }
}
