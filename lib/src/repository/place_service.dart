import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testflutter/src/config/configs.dart';
import 'package:testflutter/src/model/place_item_res.dart';
import 'package:testflutter/src/model/step_res.dart';
import 'package:testflutter/src/model/trip_info_res.dart';

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyBd5wAV2bW2aPLfc1_edSyueI75eSBz9s4&language=vi&region=VN&query=${Uri.encodeQueryComponent(keyword)}";

    print("search >>: $url");
    var res = await http.get(Uri.parse(url));
    print("Response status: ${res.statusCode}");
    print("Response body: ${res.body}");

    if (res.statusCode == 200) {
      var jsonResponse = json.decode(res.body) as Map<String, dynamic>;
      return PlaceItemRes.fromJsonList(jsonResponse);
    } else {
      throw Exception("Failed to load places");
    }
  }

  static Future<TripInfoRes> getStep(
      double lat, double lng, double tolat, double tolng) async {
    String strOrigin = "origin=$lat,$lng";
    String strDest = "destination=$tolat,$tolng";
    String sensor = "sensor=false";
    String mode = "mode=driving";
    String parameters = "$strOrigin&$strDest&$sensor&$mode";
    String output = "json";
    String url =
        "https://maps.googleapis.com/maps/api/directions/$output?$parameters&key=${Configs.ggKEY2}";

    print(url);
    var response = await http.get(Uri.parse(url));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      try {
        int distance =
            jsonResponse["routes"][0]["legs"][0]["distance"]["value"];
        List<StepsRes> steps =
            _parseSteps(jsonResponse["routes"][0]["legs"][0]["steps"]);
        return TripInfoRes(distance, steps);
      } catch (e) {
        throw Exception("Failed to parse steps");
      }
    } else {
      throw Exception("Failed to load directions");
    }
  }

  static List<StepsRes> _parseSteps(List<dynamic> stepsJson) {
    return stepsJson.map<StepsRes>((json) => StepsRes.fromJson(json)).toList();
  }
}
