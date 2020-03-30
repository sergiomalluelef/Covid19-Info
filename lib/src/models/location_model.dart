class CountryInfo {
  String iso2;
  String iso3;
  double lat;
  double long;
  String flag;

  CountryInfo({this.iso2, this.iso3, this.flag, this.lat, this.long});

  CountryInfo.fromJson(Map<String, dynamic> json) {
    iso2 = json['iso2'];
    iso3 = json['iso3'];
    flag = json['flag'];
    lat = json['lat'].toDouble();
    long = json['long'].toDouble();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['flag'] = this.flag;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    return data;
  }

}