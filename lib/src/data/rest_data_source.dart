import 'package:game/src/models/data_api_model.dart';
import 'package:game/src/models/data_global.dart';
import 'package:game/src/utils/network/http_utils.dart';

class RestDatasource {
  ///Realiza la petición de login a la api
  static Future<List<DataApiModel>> getDataApiModel() async {
    String url = 'https://corona.lmao.ninja/countries';
    return new HttpUtils().get(url).then((dynamic res) {
      print(res.toString());
      return DataApiModel.fromJsonList(res);
    });
  }
  static Future<DataGlobal> getDataGlobalpiModel() async {
    String url = 'https://corona.lmao.ninja/all';
    return new HttpUtils().get(url).then((dynamic res) {
      print(res.toString());
      return DataGlobal.fromJson(res);
    });
  }
}
