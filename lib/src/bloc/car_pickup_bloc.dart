import 'dart:async';

import 'package:testflutter/src/config/car_utils.dart';
import 'package:testflutter/src/model/car_item.dart';

class CarPickupBloc {
  final _pickupController = new StreamController();
  var carList = CarUtils.getCarList();
  get stream => _pickupController.stream;

  var currentSelected = 0;

  void selectItem(int index) {
    currentSelected = index;
    _pickupController.sink.add(currentSelected);
  }

  bool isSelected(int index) {
    return index == currentSelected;
  }

  CarItem getCurrentCar() {
    return carList.elementAt(currentSelected);
  }

  void dispose() {
    _pickupController.close();
  }
}
