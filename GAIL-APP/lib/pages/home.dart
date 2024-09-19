import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:trust_location/trust_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String _latitude = 'Fetching...';
  String _longitude = 'Fetching...';
  bool _isMockLocation = false;
  bool _permissionGranted = false;

  MapController _mapController = MapController();
  LatLng _initialPosition = LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    // requestLocationPermission();
    // TrustLocation.start(5); // Start checking location every 5 seconds
    // _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      TrustLocation.onChange.listen((values) {
        setState(() {
          _latitude = values.latitude ?? 'Unknown';
          _longitude = values.longitude ?? 'Unknown';
          _isMockLocation = values.isMockLocation ?? false;

          if (_isMockLocation) {
            TrustLocation.stop(); // Stop location updates
            _showMockLocationAlert();
          } else {
            _updateMapLocation();
          }
        });
      });
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  Future<void> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      setState(() {
        _permissionGranted = status.isGranted;
      });
      print('Permission status: $status');
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  void _updateMapLocation() {
    final lat = double.tryParse(_latitude);
    final lng = double.tryParse(_longitude);

    if (lat != null && lng != null) {
      setState(() {
        _initialPosition = LatLng(lat, lng);
      });
      _mapController.move(_initialPosition, 15.0);
    } else {
      print('Invalid latitude or longitude values');
    }
  }

  void _showMockLocationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access Denied'),
          content: const Text('Mock location detected!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                TrustLocation.start(5); // Restart location updates
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [

            Positioned(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _initialPosition,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.gail',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _initialPosition,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 100,
              child: Container(
                height: 200,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.circular(6)

                ),
              ),
            ),
       ] ),
      ),
    );
  }
}
