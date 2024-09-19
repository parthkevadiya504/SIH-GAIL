import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gail/pages/login.dart';
import 'package:gail/pages/splashscreen.dart';
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
  LatLng _initialPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    TrustLocation.start(5); // Start checking location every 5 seconds
    _getLocation();
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade100,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Attempts of GPS Spoofing will be reported',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red, // Red color for the title
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Contact Your Higer Authority To Further Access',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SplashScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue, // Blue text color
                    ),
                    child: Text(
                      'Okay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _initialPosition,
                        color: Colors.blue.withOpacity(0.3),
                        borderStrokeWidth: 2,
                        borderColor: Colors.blue,
                        radius: 100, // Radius in meters
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _initialPosition,
                        child: const Icon(
                          Icons.location_pin,
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
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
