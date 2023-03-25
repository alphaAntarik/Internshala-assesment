import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

Future<LocationData> _currentLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  Location location = new Location();

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  return await location.getLocation();
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // GoogleMapController mapController;
  // static final LatLng _center = const LatLng(45.521563, -122.677433);
  // final Set<Marker> _markers = {};
  // LatLng _currentMapPosition = _center;

  // void _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(Marker(
  //       markerId: MarkerId(_currentMapPosition.toString()),
  //       position: _currentMapPosition,
  //       infoWindow:
  //           InfoWindow(title: 'Nice Place', snippet: 'Welcome to Poland'),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  // void _onCameraMove(CameraPosition position) {
  //   _currentMapPosition = position.target;
  // }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Flutter Maps Demo'),
  //         backgroundColor: Colors.green,
  //       ),
  //       body: Stack(
  //         children: <Widget>[
  //           GoogleMap(
  //               onMapCreated: _onMapCreated,
  //               initialCameraPosition: CameraPosition(
  //                 target: _center,
  //                 zoom: 10.0,
  //               ),
  //               markers: _markers,
  //               onCameraMove: _onCameraMove),
  //           Padding(
  //             padding: const EdgeInsets.all(14.0),
  //             child: Align(
  //               alignment: Alignment.topRight,
  //               child: FloatingActionButton(
  //                   onPressed: _onAddMarkerButtonPressed,
  //                   materialTapTargetSize: MaterialTapTargetSize.padded,
  //                   backgroundColor: Colors.green,
  //                   child: //const Icon(Icons.map, size: 30.0),
  //                       Text(_currentMapPosition.latitude.toString())),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData>(
      future: _currentLocation(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
        if (snapchat.hasData) {
          final LocationData currentLocation = snapchat.data;
          return SfMaps(
            layers: [
              MapTileLayer(
                initialFocalLatLng: MapLatLng(
                    currentLocation.latitude, currentLocation.longitude),
                initialZoomLevel: 5,
                initialMarkersCount: 1,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                markerBuilder: (BuildContext context, int index) {
                  return MapMarker(
                    latitude: currentLocation.latitude,
                    longitude: currentLocation.longitude,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red[800],
                    ),
                    size: Size(20, 20),
                  );
                },
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
