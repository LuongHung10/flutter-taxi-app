import 'package:google_maps_flutter/google_maps_flutter.dart';

class StepsRes {
  LatLng startLocation;
  LatLng endLocation;
  StepsRes({required this.startLocation, required this.endLocation});
//  Steps();
  factory StepsRes.fromJson(Map<String, dynamic> json) {
    return StepsRes(
        startLocation: LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLocation:
            LatLng(json["end_location"]["lat"], json["end_location"]["lng"]));
  }
}
