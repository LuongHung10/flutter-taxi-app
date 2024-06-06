import 'package:testflutter/src/model/car_item.dart';

class CarUtils {
  static List<CarItem>? _cars;

  static List<CarItem> getCarList() {
    if (_cars != null) {
      return _cars!;
    }

    _cars = <CarItem>[
      CarItem("SEDAN", "assets/ic_pickup_sedan.png", 1.5),
      CarItem("SUV", "assets/ic_pickup_suv.png", 2),
      CarItem("VAN", "assets/ic_pickup_van.png", 2.5),
      CarItem("AUDI", "assets/ic_pickup_hatchback.png", 3),
    ];

    return _cars!;
  }
}
