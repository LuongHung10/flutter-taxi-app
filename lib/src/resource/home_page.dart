import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:testflutter/src/model/place_item_res.dart';
import 'package:testflutter/src/model/step_res.dart';
import 'package:testflutter/src/repository/place_service.dart';
import 'package:testflutter/src/resource/widget/car_pickup.dart';
import 'package:testflutter/src/resource/widget/home_menu.dart';
import 'package:testflutter/src/resource/widget/ride_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, Marker> _markers = <String, Marker>{};
  var _tripDistance = 0;
  Set<Polyline> _polylines = {};

  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: Set<Marker>.of(_markers.values),
              polylines: _polylines,
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.7915178, 106.7271422),
                zoom: 14.4746,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: const Text(
                      "Taxi App",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: TextButton(
                        onPressed: () {
                          print("click menu");
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Image.asset("assets/ic_menu.png")),
                    actions: <Widget>[Image.asset("assets/ic_notify.png")],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 40,
              height: 248,
              child: CarPickup(_tripDistance),
            )
          ],
        ),
      ),
      drawer: const Drawer(
        child: HomeMenu(),
      ),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";
    _addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlaceItemRes place) {
    // Remove old marker
    setState(() {
      _markers.remove(mkId);

      var marker = Marker(
        markerId: MarkerId(mkId),
        position: LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title: place.name, snippet: place.address),
      );

      _markers[mkId] = marker;
    });
  }

  void _moveCamera() {
    print("move camera: ");
    print(_markers);

    if (_markers.length > 1) {
      var fromLatLng = _markers["from_address"]!.position;
      var toLatLng = _markers["to_address"]!.position;

      var sLat = fromLatLng.latitude <= toLatLng.latitude
          ? fromLatLng.latitude
          : toLatLng.latitude;
      var nLat = fromLatLng.latitude >= toLatLng.latitude
          ? fromLatLng.latitude
          : toLatLng.latitude;
      var sLng = fromLatLng.longitude <= toLatLng.longitude
          ? fromLatLng.longitude
          : toLatLng.longitude;
      var nLng = fromLatLng.longitude >= toLatLng.longitude
          ? fromLatLng.longitude
          : toLatLng.longitude;

      LatLngBounds bounds = LatLngBounds(
        northeast: LatLng(nLat, nLng),
        southwest: LatLng(sLat, sLng),
      );
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      var firstMarkerPosition = _markers.values.first.position;
      _mapController.animateCamera(CameraUpdate.newLatLng(firstMarkerPosition));
    }
  }

  void _checkDrawPolyline() async {
    // Remove old polyline
    setState(() {
      _polylines.clear();
    });

    if (_markers.length > 1) {
      var from = _markers["from_address"]!.position;
      var to = _markers["to_address"]!.position;

      var infoRes = await PlaceService.getStep(
          from.latitude, from.longitude, to.latitude, to.longitude);

      if (infoRes != null) {
        var _tripDistance = infoRes.distance;
        setState(() {});

        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = [];

        for (var t in rs) {
          paths
              .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }

        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('polyline'),
            points: paths,
            color: const Color(0xFF3ADF00),
            width: 10,
          ));
        });
      }
    }
  }
}
