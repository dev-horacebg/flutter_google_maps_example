import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Maps Example",
      home: MapExample(),
    );
  }
}

class MapExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapExampleState();
}

class MapExampleState extends State<MapExample> {
  final List<MapDestination> _destinations = [
    MapDestination("The London Eye", _kLondonEye),
    MapDestination("The Shard", _kTheShard),
    MapDestination("Big Ben", kBigBen),
    MapDestination("Buckingham Palace", kBuckPal),
    MapDestination("Tower of London", kTowerLondon),
    MapDestination("The British Museum", kBritishMuseum),
    MapDestination("St Paul's Cathedral", kStPauls)
  ];

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kLondonEye =
      CameraPosition(target: LatLng(51.503399, -0.119519), zoom: 14.4746);

  static final CameraPosition _kTheShard = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(51.504501, -0.086500),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final CameraPosition kBigBen =
  CameraPosition(target: LatLng(51.5003646652, -0.1214328476), zoom: 29.8, tilt: 60);

  static final CameraPosition kBuckPal =
  CameraPosition(target: LatLng(51.501476, -0.140634), zoom: 14.4746);

  static final CameraPosition kTowerLondon =
  CameraPosition(target: LatLng(51.508530, -0.076132), zoom: 14.4746);

  static final CameraPosition kBritishMuseum =
  CameraPosition(target: LatLng(51.518757, -0.126168), zoom: 14.4746);

  static final CameraPosition kStPauls =
  CameraPosition(target: LatLng(51.513245, -0.098341), zoom: 24.4746, bearing: 181.25, tilt: 90);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: List<Marker>.generate(_destinations.length, (index) {
          return Marker(markerId: MarkerId(index.toString()), position: _destinations[index].cameraPosition.target);
      }).toSet(),
        mapType: MapType.normal,
        initialCameraPosition: _kLondonEye,
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _destinationModalBottomSheet(context);
        },
        label: Text("Next Destination!"),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToDestination(CameraPosition destination) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(destination));
  }

  void _destinationModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: Wrap(
              children: List<Widget>.generate(_destinations.length, (index) {
                return ListTile(
                    title: Text(_destinations[index].name),
                    onTap: () {
                      Navigator.pop(context);
                      _goToDestination(_destinations[index].cameraPosition);
                    });
              }),
            ),
          );
        });
  }
}

class MapDestination {
  final String name;
  final CameraPosition cameraPosition;

  MapDestination(this.name, this.cameraPosition);
}
