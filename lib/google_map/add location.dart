import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  Set<Marker> markers = {};
  late Location _locationService;
  late GoogleMapController mapController;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _locationService = Location();
    _loadMarkersFromFirestore(); // Load markers from Firestore when the widget is created
  }

  Future<void> _loadMarkersFromFirestore() async {
    Set<Marker> loadedMarkers = await loadMarkersFromFirestore();
    setState(() {
      markers = loadedMarkers;
    });
  }

  Future<void> saveMarkerToFirestore(Marker marker) async {
    await FirebaseFirestore.instance.collection('markers').add({
      'position': GeoPoint(marker.position.latitude, marker.position.longitude),
      'title': marker.infoWindow.title,
      'snippet': marker.infoWindow.snippet,
    });
  }

  Future<Set<Marker>> loadMarkersFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('markers').get();

    return querySnapshot.docs.map((doc) {
      GeoPoint position = doc['position'];
      return Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: doc['title'],
          snippet: doc['snippet'],
        ),
      );
    }).toSet();
  }

  void _saveMarkers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> markersList = markers
        .map((marker) =>
            '${marker.markerId.value},${marker.position.latitude},${marker.position.longitude},${marker.infoWindow.title},${marker.infoWindow.snippet}')
        .toList();
    prefs.setStringList('markers', markersList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Locations'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(30.033, 31.233),
          zoom: 14.0,
        ),
        markers: Set.from(markers),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng latLng) {
          // You can handle map taps if needed
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  _getCurrentLocation();
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.location_searching, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: FloatingActionButton(
                onPressed: () {
                  _pickLocation(context);
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await _locationService.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _locationService.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await _locationService.getLocation();
    LatLng currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLocation, zoom: 18.0),
    ));

    setState(() {
      _currentLocation = currentLocation;
    });
  }

  void _pickLocation(BuildContext context) async {
    final LocationInfo? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddLocationPage(currentLocation: _currentLocation),
      ),
    );

    if (result != null) {
      final markerId = MarkerId('m${markers.length}');
      Marker newMarker = Marker(
        markerId: markerId,
        position: result.location,
        infoWindow: InfoWindow(
          title: result.name,
          snippet:
              'Number: ${result.number}, Lat: ${result.location.latitude}, Lng: ${result.location.longitude}',
        ),
      );

      markers.add(newMarker);
      saveMarkerToFirestore(newMarker); // Save marker to Firestore immediately
      setState(() {});
    }
  }

  @override
  void dispose() {
    _saveMarkers(); // Save markers when the widget is disposed
    super.dispose();
  }
}

class AddLocationPage extends StatefulWidget {
  final LatLng? currentLocation;

  const AddLocationPage({super.key, this.currentLocation});

  @override
  _AddLocationPageState createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  late GoogleMapController mapController;
  LatLng? _pickedLocation;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.currentLocation ?? const LatLng(30.033, 31.233),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: (LatLng latLng) {
                _selectLocation(latLng);
              },
              markers: _pickedLocation != null
                  ? {
                      Marker(
                        markerId: const MarkerId('m1'),
                        position: _pickedLocation!,
                      ),
                    }
                  : {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Location Name'),
                ),
                TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(labelText: 'Location Number'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveLocation(context);
                  },
                  child: const Text('Save Location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectLocation(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  void _saveLocation(BuildContext context) {
    if (_pickedLocation != null) {
      Navigator.pop(
        context,
        LocationInfo(
          name: _nameController.text,
          number: _numberController.text,
          location: _pickedLocation!,
        ),
      );
    }
  }
}

class LocationInfo {
  final String name;
  final String number;
  final LatLng location;

  LocationInfo({
    required this.name,
    required this.number,
    required this.location,
  });
}
