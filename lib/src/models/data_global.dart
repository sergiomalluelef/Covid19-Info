class DataGlobal {
  int cases;
  int deaths;
  int recovered;
  int updated;
  int active;

  DataGlobal({this.cases, this.deaths, this.recovered, this.updated, this.active});

  DataGlobal.fromJson(Map<String, dynamic> json) {
    cases = json['cases'];
    deaths = json['deaths'];
    recovered = json['recovered'];
    updated = json['updated'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cases'] = this.cases;
    data['deaths'] = this.deaths;
    data['recovered'] = this.recovered;
    data['updated'] = this.updated;
    data['active'] = this.active;
    return data;
  }

}
