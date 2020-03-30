import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/src/data/database_helper.dart';
import 'package:game/src/data/rest_data_source.dart';
import 'package:game/src/models/data_api_model.dart';
import 'package:game/src/models/data_global.dart';
import 'package:game/src/utils/dimens.dart';
import 'package:game/src/utils/network/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataCov19 with ChangeNotifier {
  List<DataApiModel> _listDataApi;
  List<Marker> _listMarkers = new List<Marker>();
  DataGlobal _dataGlobal;
  List<DataApiModel> _searchResult = [];

  DataApiModel _paisResumen;

  List<DataApiModel> get listDataApi => _listDataApi;

  List<Marker> get listMarkers => _listMarkers;

  DataGlobal get dataGlobal => _dataGlobal;

  DataApiModel get paisResumen => _paisResumen;

  set paisResumen(DataApiModel value) {
    _paisResumen = value;
  }

  List<DataApiModel> get searchResult => _searchResult;

  Future<List<DataApiModel>> getDataApiCod19() async {
    var db = new DatabaseHelper();
    _listDataApi = new List();
    String pathImage = 'assets/images/covid.png';
    await RestDatasource.getDataApiModel().then((value) {
      _listDataApi = value;
      db.deleteAll(db.COUNTRY);
      db.insertAll(db.COUNTRY, this._listDataApi);
    }).catchError((Object error) async {
      print('Error: ' + error.toString());
     await db.selectAllCountry().then((list){
        if(list.length > 0){
          _listDataApi = list;
          print('Datos recuperados de BD');
        }else{
          print('Error al recupera data total: ' + error.toString());
          _listDataApi = null;
        }
      }).catchError((Object error ){
        print('Error al recupera data total: ' + error.toString());
        _listDataApi = null;
      });

    });
    if(_listDataApi != null){
      await BitmapDescriptor.fromAssetImage(ImageConfiguration(), pathImage).then(
            (onValue) {
          _listDataApi.forEach(
                (e) {
              listMarkers.add(
                Marker(
                  draggable: true,
                  markerId: MarkerId('${e.countryInfo.lat}'),
                  position: LatLng(e.countryInfo.lat, e.countryInfo.long),
                  icon: onValue,
                  infoWindow: InfoWindow(
                    title: "${e.country}".toUpperCase(),
                    snippet: "${Utils.setFormatNumberToString(e.cases)} confirmados" +
                        (e.deaths > 0 ? ", ${Utils.setFormatNumberToString(e.deaths)} fallecidos" : "") +
                        (e.recovered > 0
                            ? " y ${Utils.setFormatNumberToString(e.recovered)} recuperados"
                            : ""),
                    //En android no funciona el salto de linea...
                  ),
                ),
              );
            },
          );
        },
      );
    }
    _listDataApi.sort((a, b) => b.cases.compareTo(a.cases));
    notifyListeners();
    return _listDataApi;

  }

  void getDataCountry(String name) async {
    final List<DataApiModel> list = _listDataApi.where((f) => f.country.toUpperCase().contains(name.toUpperCase())).toList();
    this.paisResumen = list.length > 0 ? list[0] : null;
    notifyListeners();
  }

  void getOrderDataApiCod19(int text) async {
    if (text == 0) {
      _listDataApi.sort((a, b) => b.cases.compareTo(a.cases));
    } else if (text == 1) {
      _listDataApi.sort((a, b) => b.deaths.compareTo(a.deaths));
    } else if (text == 2) {
      _listDataApi.sort((a, b) => b.recovered.compareTo(a.recovered));
    }
    notifyListeners();
  }

  Future<DataGlobal> getDataGlobalApiCod19(ScaffoldState state) async {
    var db = new DatabaseHelper();
    await RestDatasource.getDataGlobalpiModel().then((value) {
      _dataGlobal = value;
      db.deleteAll(db.GLOBAL);
      db.saveUsDataGlobal(_dataGlobal);
      if(state != null) {
        state.showSnackBar(
            showMessage('Datos actualizados correctamente'));
      }
    }).catchError((Object error) async {
      await db.getDataGlobal().then((data){
        if(data != null){
          _dataGlobal = data;
          print('Datos Globales de BD');
          if(state != null){
            state.showSnackBar(showMessage('Error al actualizar: se recuperan datos locales'));
          }
        }else{
          print('Error al recupera Globales: ' + error.toString());
          _dataGlobal =  null;
          if(state != null){
            state.showSnackBar(showMessage('Error al actualizar'));
          }
        }
      }).catchError((Object error ){
        print('Error al recupera Globales: ' + error.toString());
        if(state != null){
          state.showSnackBar(showMessage('Error al actualizar'));
        }
        _dataGlobal = null;
      });

    });
    notifyListeners();
    return _dataGlobal;
  }
  Widget showMessage(String text){
    return SnackBar(content: Container(height: 25,child: Align(alignment: Alignment.center,child: Text(text, style: TextStyle(color: Color(0xFF584E5E), fontSize: textSmall),))));
  }


  void getSearchDataApiCod19(String text) async {
    _searchResult.clear();
    notifyListeners();
    if (text.isEmpty) {
      notifyListeners();
      return null;
    }
    _searchResult = _listDataApi.where((f) => f.country.toUpperCase().contains(text.toUpperCase())).toList();
    notifyListeners();
  }

  String getPercentageOfTotal(int quantity, int cases){
    double porcentage = (100 * quantity)/cases;
    return porcentage.toStringAsFixed(1) + "%";
  }
}
