import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await initNotifications();

  runApp(const MyApp());
}

// Initialize notifications
Future<void> initNotifications() async {
  await AwesomeNotifications().initialize(
    null, // No icon for this example, use your app icon path for production
    [
      NotificationChannel(
        channelKey: 'geofence_channel',
        channelName: 'Geofence Notifications',
        channelDescription: 'Notifications for geofence entry and exit',
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      )
    ],
  );

  // Request notification permissions
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

// Show notification
Future<void> showNotification({
  required String title,
  required String body,
  required bool isEntering,
}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: isEntering ? 1 : 2, // Different IDs for enter vs exit
      channelKey: 'geofence_channel',
      title: title,
      body: body,
      color: isEntering ? Colors.green : Colors.red,
      category: NotificationCategory.Status,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geofencing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GeofencingHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GeofenceArea {
  final String name;
  final String serviceId;
  final LatLng center;
  final double radius; // in meters

  GeofenceArea({
    required this.name,
    required this.serviceId,
    required this.center,
    required this.radius,
  });
}

class GeofencingHomePage extends StatefulWidget {
  const GeofencingHomePage({Key? key}) : super(key: key);

  @override
  _GeofencingHomePageState createState() => _GeofencingHomePageState();
}

class _GeofencingHomePageState extends State<GeofencingHomePage> {
  // Map controller
  final MapController _mapController = MapController();

  // Current user location
  LatLng? _currentUserLocation;

  // Status of user inside geofence
  bool _isInsideGeofence = false;
  bool _previousGeofenceStatus = false;

  // Stream subscription for location updates
  StreamSubscription<Position>? _positionStreamSubscription;

  // Audio player for sounds
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Geofence area (static for now)
  final GeofenceArea _geofenceArea = GeofenceArea(
    name: "Office",
    serviceId: "office-001",
    center: LatLng(23.042417, 72.634433),
    radius: 20, // 20 meters radius
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();

    // Listen for notification actions (e.g., if a user taps on a notification)
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _GeofencingHomePageState.onActionReceivedMethod,
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // This method would be called when the app handles notification actions
  // It must be a static or top-level function
  // This must be a top-level or static function
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Here you can navigate to specific screens based on the notification action
    print('Notification action received: ${receivedAction.id}');
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied, please enable in settings'),
        ),
      );
      return;
    }

    _getCurrentLocation();
    _startLocationUpdates();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
        _checkIfUserInGeofence();
      });

      _mapController.move(_currentUserLocation!, 15.0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _startLocationUpdates() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5, // Update if moved 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentUserLocation = LatLng(position.latitude, position.longitude);
        _checkIfUserInGeofence();
      });
    });
  }

  void _checkIfUserInGeofence() {
    if (_currentUserLocation == null) return;

    // Save previous status for comparison
    _previousGeofenceStatus = _isInsideGeofence;

    // Calculate distance between user and geofence center
    double distanceInMeters = const Distance().as(
      LengthUnit.Meter,
      _geofenceArea.center,
      _currentUserLocation!,
    );

    bool isInside = distanceInMeters <= _geofenceArea.radius;

    // Only update state if there's a change
    if (isInside != _isInsideGeofence) {
      setState(() {
        _isInsideGeofence = isInside;
      });

      // Notify about the change
      _handleGeofenceStatusChange();

      // Here you would typically send an update to your Django backend
      _updateGeofenceStatus(_isInsideGeofence);
    }
  }

  Future<void> _handleGeofenceStatusChange() async {
    // Get the current timestamp
    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final timestampStr = '$formattedTime, $formattedDate';

    if (_isInsideGeofence && !_previousGeofenceStatus) {
      // User has entered the geofence
      await _playSound('enter');
      await showNotification(
        title: '🟢 Geofence Entry Alert',
        body: '✅ You have entered the ${_geofenceArea.name} area\n⏱️ $timestampStr',
        isEntering: true,
      );
    } else if (!_isInsideGeofence && _previousGeofenceStatus) {
      // User has exited the geofence
      await _playSound('exit');
      await showNotification(
        title: '🔴 Geofence Exit Alert',
        body: '❌ You have left the ${_geofenceArea.name} area\n⏱️ $timestampStr',
        isEntering: false,
      );
    }
  }

  Future<void> _playSound(String type) async {
    try {
      // You'll need to add these sound files to your assets
      String soundPath = type == 'enter'
          ? 'sounds/enter.mp3'
          : 'sounds/exit.mp3';

      // Play the sound
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> _updateGeofenceStatus(bool isInside) async {
    // In a real app, this would send the status to your Django backend
    // For now, just print to console
    print('User is ${isInside ? "inside" : "outside"} the geofence');

    // Example of how you would use Dio to update the backend
    try {
      // This is just a placeholder and won't actually work without your backend
      final dio = Dio();
      /*
      await dio.post(
        'https://your-django-api.com/update-geofence-status/',
        data: {
          'service_id': _geofenceArea.serviceId,
          'is_inside': isInside,
          'latitude': _currentUserLocation!.latitude,
          'longitude': _currentUserLocation!.longitude,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      */
    } catch (e) {
      print('Failed to update geofence status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geofencing App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: _isInsideGeofence ? Colors.green : Colors.red,
            width: double.infinity,
            child: Text(
              _isInsideGeofence
                  ? 'You are inside the geofenced area'
                  : 'You are outside the geofenced area',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Map view
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _geofenceArea.center,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),

                // Geofence circle
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _geofenceArea.center,
                      radius: _geofenceArea.radius,
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2.0,
                    ),
                  ],
                ),

                // Geofence center marker
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _geofenceArea.center,
                      width: 60,
                      height: 60,
                      child:  const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),

                // User location marker (if available)
                if (_currentUserLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentUserLocation!,
                        width: 60,
                        height: 60,
                        child:  const Icon(
                          Icons.person_pin_circle,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Information panel
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Geofence: ${_geofenceArea.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Service ID: ${_geofenceArea.serviceId}'),
                Text('Radius: ${_geofenceArea.radius} meters'),
                if (_currentUserLocation != null)
                  Text('Your location: ${_currentUserLocation!.latitude.toStringAsFixed(6)}, ${_currentUserLocation!.longitude.toStringAsFixed(6)}'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

// cupertino_icons: ^1.0.8
// flutter_sim_data: ^1.0.5
// permission_handler: ^11.0.1  # Get current location
// flutter_map: ^4.0.0
// dio: ^5.3.2
// flutter_map_marker_cluster: ^1.1.0
// geolocator: ^9.0.2
// # New dependencies
// audioplayers: ^5.2.1             # For playing sounds
// awesome_notifications: ^0.8.2