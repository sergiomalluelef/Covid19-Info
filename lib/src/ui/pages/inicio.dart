import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/src/models/data_global.dart';
import 'package:game/src/provider/data_cod19.dart';
import 'package:game/src/utils/dimens.dart';
import 'package:game/src/utils/network/Utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  bool isRefresh = false;
  @override
  Widget build(BuildContext buildContext) {
    return Consumer<DataCov19>(builder: (context, dataCod19, _) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 48),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    title('Datos globales'),
                    IconButton(icon: Icon(Icons.refresh), onPressed: (){
                      setState(() {
                        isRefresh = true;
                      });
                      Provider.of<DataCov19>(context, listen: false).getDataApiCod19().then((value)  {
                        if(value != null && value.isNotEmpty){
                          debugPrint('datos encontrados');
                          Provider.of<DataCov19>(context, listen: false).getDataGlobalApiCod19(Scaffold.of(context)).then((value){
                            if(value != null){
                              Provider.of<DataCov19>(context, listen: false).getDataCountry('Chile');
                              setState(() {
                                isRefresh = false;
                              });
                            }else{
                              setState(() {
                                isRefresh = false;
                              });
                            }
                          });
                        }else{
                          setState(() {
                            isRefresh = false;
                          });
                        }
                      }).catchError((Object error ){
                        setState(() {
                          isRefresh = false;
                        });
                      });
                    })
                  ],
                ),
                isRefresh ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 20.0,
                    width: 20.0,
                  )
                ) : Container(),
                totalCasos('Confirmados', dataCod19.dataGlobal.cases, dataCod19),
                title('¿Qué pasa en Chile?'),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    elevation: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.grey[900],
                                Colors.black45
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              Utils.setFormatNumberToString(dataCod19.paisResumen.cases),
                              style:
                              TextStyle(
                                  color: Colors.white, fontSize: textExtraLarge),
                            ),
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: textMedium,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 2,
                                color: Color(0xFF584E5E),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                resumenPaisItems('Activos', dataCod19.paisResumen.active, dataCod19, dataCod19.paisResumen.cases,),
                                resumenPaisItems('Recuperados', dataCod19.paisResumen.recovered, dataCod19, dataCod19.paisResumen.cases),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                resumenPaisItems('Fallecidos', dataCod19.paisResumen.deaths, dataCod19, dataCod19.paisResumen.cases),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                title('Últimos registros'),
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    elevation: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.grey[900],
                                Colors.black45
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                resumenPais24HourItems('Nuevos', dataCod19.paisResumen.todayCases,),
                                resumenPais24HourItems('Fallecidos', dataCod19.paisResumen.todayDeaths),
                                resumenPais24HourItems('Críticos', dataCod19.paisResumen.critical),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Últimos datos el ' + formatTimestamp(dataCod19.dataGlobal.updated),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: textSmall),
                ),
              ),
            )

              ],
            ),
          ),
        ),
      );
    });
  }


  String formatTimestamp(int timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    print('Fecha: ' + date.millisecondsSinceEpoch.toString());
    return format.format(date);
  }

  Widget title(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: textLarge),
        ),
      ),
    );
  }

  Widget totalCasos(String titulo, int data, DataCov19 dataCod19) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color(0xFF584E5E),
                    Colors.grey[900],
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
          width: double.infinity,
          padding: EdgeInsets.only(left: 8, right: 8, top: 16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Utils.setFormatNumberToString(data),
                  style:
                  TextStyle(color: Colors.white, fontSize: textExtraLarge),
                ),
                Text(
                  "$titulo",
                  style: TextStyle(
                    fontSize: textMedium,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Carousel(
                      autoplay: true,
                      dotSize: 4,
                      autoplayDuration: Duration(seconds: 8),
                      dotBgColor: Colors.transparent,
                      dotColor: Color(0xffF0EFF4),
                      dotIncreasedColor: Colors.grey,
                      images: [
                        resumenTotalItems('Activos',
                            dataCod19.dataGlobal.active, dataCod19, dataCod19.dataGlobal.cases),
                        resumenTotalItems('Fallecidos',
                            dataCod19.dataGlobal.deaths, dataCod19,dataCod19.dataGlobal.cases),
                        resumenTotalItems(
                            'Recuperados',
                            dataCod19.dataGlobal.recovered,
                            dataCod19,
                        dataCod19.dataGlobal.cases),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  Widget resumenTotalItems(String title, int quantity, DataCov19 dataGlobal,int cases) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                Utils.setFormatNumberToString(quantity),
                style: TextStyle(color: Colors.white, fontSize: textExtraLarge),
              ),
              Text(
                '(' + dataGlobal.getPercentageOfTotal(quantity,cases) + ')',
                style: TextStyle(color: Colors.white, fontSize: textExtraLarge),
              ),
            ],
          ),
          Text("$title",
              style: TextStyle(
                color: Colors.grey,
                fontSize: textMedium,
              )),
        ],
      ),
    );
  }
  Widget resumenPaisItems(String title, int quantity, DataCov19 dataGlobal,int cases) {

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      Utils.setFormatNumberToString(quantity),
                      style: TextStyle(color: Colors.white, fontSize: textExtraLarge),
                    ),
                    Text(
                      '(' + dataGlobal.getPercentageOfTotal(quantity,cases) + ')',
                      style: TextStyle(color: Colors.grey, fontSize: textLarge),
                    ),
                    Text("$title",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: textMedium,
                        )),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget resumenPais24HourItems(String title, int quantity) {

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      Utils.setFormatNumberToString(quantity),
                      style: TextStyle(color: Colors.white, fontSize: textExtraLarge),
                    ),
                    Text("$title",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: textMedium,
                        )),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
