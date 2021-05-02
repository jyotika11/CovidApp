class Covid {
  int india_confvalue;
  int india_recvalue;
  int india_deaths;
  String india_lastupdate;
  int ts_confvalue;
  int ts_recvalue;
  int ts_deaths;
  String ts_lastupdate;

  Covid({
    this.india_confvalue,
    this.india_deaths,
    this.india_lastupdate,
    this.india_recvalue,
    this.ts_confvalue,
    this.ts_deaths,
    this.ts_lastupdate,
    this.ts_recvalue
  });

  factory Covid.fromJson(Map < dynamic, dynamic > json) {
      return Covid(
          india_confvalue: int.parse(json["total_values"]['confirmed']),
          india_recvalue: int.parse(json["total_values"]['recovered']),
          india_deaths: int.parse(json["total_values"]['deaths']),
          india_lastupdate: json["total_values"]['lastUpdate'],
          ts_confvalue: int.parse(json["state_wise"]["Telangana"]['confirmed']),
          ts_recvalue: int.parse(json["state_wise"]["Telangana"]['recovered']),
          ts_deaths: int.parse(json["state_wise"]["Telangana"]['deaths']),
          ts_lastupdate: json["state_wise"]["Telangana"]['lastUpdate']);
  }
}