import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MapDemoApp());
}

class MapDemoApp extends StatelessWidget {
  const MapDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map Demo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  // Initial location: Mumbai
  static const LatLng initialLocation = LatLng(
    19.0760,
    72.8777,
  );

  LatLng? currentLocation;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;

    LocationPermission permission;

    // Check whether location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();

    // Request permission if not already granted
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    // Permission permanently denied
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      // Add marker for current location
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation!,
          infoWindow: const InfoWindow(
            title: 'You are here',
            snippet: 'Current device location',
          ),
        ),
      );

      // Add another marker
      markers.add(
        const Marker(
          markerId: MarkerId('college'),
          position: LatLng(19.1197, 72.8468),
          infoWindow: InfoWindow(
            title: 'College',
            snippet: 'College location',
          ),
        ),
      );

      // Add another point of interest
      markers.add(
        const Marker(
          markerId: MarkerId('mumbai'),
          position: LatLng(19.0760, 72.8777),
          infoWindow: InfoWindow(
            title: 'Mumbai',
            snippet: 'Mumbai city',
          ),
        ),
      );
    });

    // Move camera to current location
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation!,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _moveToCurrentLocation() {
    if (currentLocation != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLocation!,
            zoom: 16,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Demo App'),
        centerTitle: true,
      ),

      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: initialLocation,
          zoom: 11,
        ),

        // Display markers
        markers: markers,

        // Show Google's current-location indicator
        myLocationEnabled: true,

        // Show location button
        myLocationButtonEnabled: false,

        // Allow zoom controls
        zoomControlsEnabled: true,

        // Called when map is created
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;

          // If current location is already available,
          // move camera to it.
          if (currentLocation != null) {
            _moveToCurrentLocation();
          }
        },
      ),

      // Re-center button
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}