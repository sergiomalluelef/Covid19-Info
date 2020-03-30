import 'package:game/src/models/location_model.dart';
import 'dart:convert';

class DataApiModel {
  String country;
  CountryInfo countryInfo;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;

  DataApiModel(
      {this.country,
        this.countryInfo,
        this.cases,
        this.todayCases,
        this.deaths,
        this.todayDeaths,
        this.recovered,
        this.active,
        this.critical});

  DataApiModel.fromJson(Map<String, dynamic> jsonData) {
    country = jsonData['country'];
    countryInfo = jsonData['countryInfo'] != null
        ? jsonData['countryInfo'] is String ? new CountryInfo.fromJson(json.decode(jsonData['countryInfo'])) : new CountryInfo.fromJson(jsonData['countryInfo'])
        : null;
    cases = jsonData['cases'];
    todayCases = jsonData['todayCases'];
    deaths = jsonData['deaths'];
    todayDeaths = jsonData['todayDeaths'];
    recovered = jsonData['recovered'];
    active = jsonData['active'];
    critical = jsonData['critical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.countryInfo != null) {
      data['countryInfo'] = json.encode(this.countryInfo.toJson());
    }
    data['cases'] = this.cases;
    data['todayCases'] = this.todayCases;
    data['deaths'] = this.deaths;
    data['todayDeaths'] = this.todayDeaths;
    data['recovered'] = this.recovered;
    data['active'] = this.active;
    data['critical'] = this.critical;
    return data;
  }

  static List<DataApiModel> fromJsonList(List<dynamic> jsonList) {
    List<DataApiModel> list = [];
    jsonList.forEach((dynamic json) {
      list.add(DataApiModel.fromJson(json));
    });
    return list;
  }
}
