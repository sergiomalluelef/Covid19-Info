import 'package:flutter/material.dart';
import 'package:game/src/provider/data_cod19.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {

  const Splash({
    Key key,
  }) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    // >>> CARGA DE DATOS
     Provider.of<DataCov19>(context, listen: false).getDataApiCod19().then((value)  {
      if(value != null && value.isNotEmpty){
        debugPrint('datos encontrados');
         Provider.of<DataCov19>(context, listen: false).getDataGlobalApiCod19(null).then((value){
          if(value != null){
            Provider.of<DataCov19>(context, listen: false).getDataCountry('Chile');
            Navigator.pushReplacementNamed(context, '/home');
          }else{
            errorData();
          }
        });
      }else{
        errorData();
      }
    }).catchError((Object error ){
      print('error: '+error.toString());
    });
  }

  void errorData() {
    debugPrint('datos no encontrados');
    setState(() {
      _hasError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    if (_hasError) {
      return  Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: Lottie.asset('assets/lottie/virus_error.json', width: 200),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ups! algo salió mal.'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('No hemos podido recuperar los datos'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('¿Quieres reintentar?'),
                    ),
                    RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        child: Text('Reintentar'),
                        onPressed: () {
                          setState(() {
                            _hasError = false;
                          });
                          _initializeAsyncDependencies();
                        }
                    ),
                  ],
                ),

              ],
            )
        ),
      );
    }
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Lottie.asset('assets/lottie/mascarilla.json', width: 200),
              ),
              CircularProgressIndicator()
            ],
          )
      ),
    );
  }
}