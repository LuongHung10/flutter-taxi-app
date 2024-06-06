class PlaceItemRes {
  String name;
  String address;
  double lat;
  double lng;

  PlaceItemRes(this.name, this.address, this.lat, this.lng);

  factory PlaceItemRes.fromJson(Map<String, dynamic> json) {
    return PlaceItemRes(
      json['name'] ?? 'Unknown name',
      json['formatted_address'] ?? 'Unknown address',
      json['geometry']['location']['lat'] ?? 0.0,
      json['geometry']['location']['lng'] ?? 0.0,
    );
  }

  static List<PlaceItemRes> fromJsonList(Map<String, dynamic> json) {
    print("Parsing data");
    List<PlaceItemRes> rs = [];

    var results = json['results'] as List;
    for (var item in results) {
      rs.add(PlaceItemRes.fromJson(item));
    }

    return rs;
  }
}
