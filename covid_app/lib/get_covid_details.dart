import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/Covid.dart';

Covid covid_res;

loadCount() async {
  print("LoadCount");
  covid_res = await getCount();
  print("covid deaths in India: ${covid_res.india_deaths.toString()}");
  print("covid deaths in Telangana: ${covid_res.ts_deaths.toString()}");

}

Future<Covid> getCount() async {
  print("GetIndiaCount");
  try {
    final response = await http.get(
        Uri.https("corona-virus-world-and-india-data.p.rapidapi.com","/api_india"),
        headers: {
          "x-rapidapi-key": "78a9ed9046msh1d53368c0eed6c8p1372b6jsnb388bc3eb5ad",
          "x-rapidapi-host": "corona-virus-world-and-india-data.p.rapidapi.com",
          "useQueryString": "true"
        });
    var body = response.body;
    return Covid.fromJson(jsonDecode(body));
  } on Exception catch(ex){
    print("Caught Exception $ex");
  }
}


