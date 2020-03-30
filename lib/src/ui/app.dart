
import 'package:flutter/material.dart';
import 'package:game/src/provider/data_cod19.dart';
import 'package:game/src/ui/pages/home.dart';
import 'package:game/src/ui/pages/splash.dart';
import 'package:provider/provider.dart';

import 'pages/map_cod19.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataCov19()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'COVID-19',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey[900],
          accentColor: Color(0xFF584E5E),
          buttonColor: Color(0xFF584E5E),
          fontFamily: 'AvenirNextLTPro',
        ),
        routes: {
          '/': (context) => Splash(),
          '/home': (context) => Home(),
          '/map': (context) => MapCod19(),
        },
      ),
    );
  }
}
