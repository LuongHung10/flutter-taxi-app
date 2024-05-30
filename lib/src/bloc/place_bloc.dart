import 'dart:async';

import 'package:testflutter/src/repository/place_service.dart';

class PlaceBloc {
  final _placeController = StreamController();
  Stream get placeStream => _placeController.stream;

  void searchPlace(String keyword) {
    print("place bloc search: " + keyword);

    _placeController.sink.add("start");
    PlaceService.searchPlace(keyword).then((rs) {
      _placeController.sink.add(rs);
      // ignore: argument_type_not_assignable_to_error_handler
    }).catchError(() {
//      _placeController.sink.add("stop");
    });
  }

  void dispose() {
    _placeController.close();
  }
}
