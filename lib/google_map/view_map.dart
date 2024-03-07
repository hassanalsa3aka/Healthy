import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:healthy/patient/patient_home.dart';
import 'package:healthy/patient/patient_profile.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewMapPage extends StatefulWidget {
  const ViewMapPage({super.key});

  @override
  _ViewMapPageState createState() => _ViewMapPageState();
}

class _ViewMapPageState extends State<ViewMapPage> {
  late GoogleMapController mapController;
  late Location _locationService;
  LatLng? _currentLocation;
  Set<Marker> markers = {};
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _locationService = Location();
    _loadMarkersFromFirestore();
  }

  Future<void> _loadMarkersFromFirestore() async {
    Set<Marker> loadedMarkers = await loadMarkersFromFirestore();
    setState(() {
      markers = loadedMarkers;
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

  @override
  Widget build(BuildContext context) {
    return _buildScaffoldWithBottomNavigationBar();
  }

  Widget _buildScaffoldWithBottomNavigationBar() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Map'),
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
          // Handle map taps if needed
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.location_searching, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
      ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            duration: const Duration(milliseconds: 800),
            tabBackgroundColor: Colors.black,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (_selectedIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PtHome()),
                );
              } else if (_selectedIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewMapPage()),
                );
              } else if (_selectedIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PtProfile()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
