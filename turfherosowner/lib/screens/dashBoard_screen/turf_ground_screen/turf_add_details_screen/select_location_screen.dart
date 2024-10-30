// ignore_for_file: unused_field, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:turf_heros_owner/const/appConstns/AppConstns.dart';
import 'package:turf_heros_owner/viewmodel/api_viewmodel.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;
  LatLng? _initialCenter;
  late LatLng _currentCenter;
  Marker? _centerMarker;
  loc.LocationData? _currentPosition;
  String? _currentAddress;
  late loc.Location location;
  late StreamSubscription<loc.LocationData> _locationSubscription;
  final appVariable = Get.put(EditTurfGroundDataViewModel());
  final variableAdd =  Get.put(AddTurfGroundDataViewModel());
  final variable = Get.put(AppConstns());
  Placemark? place;
  @override
  void initState() {
    super.initState();
    location = loc.Location();
    _initialCenter = LatLng(
      variable.currentPosition.latitude,
      variable.currentPosition.longitude,
    );

    _locationSubscription =
        location.onLocationChanged.listen((loc.LocationData currentLocation) {
      setState(() {
        _currentPosition = currentLocation;
        _currentCenter =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
        _updateMarker(_currentCenter);
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription
        .cancel(); // Cancel the location subscription to avoid memory leaks
    mapController.dispose(); // Dispose the map controller
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _currentCenter = _initialCenter!;
    _updateMarker(_currentCenter);
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _centerMarker = Marker(
        markerId: const MarkerId("center_marker"),
        position: position,
        infoWindow: const InfoWindow(title: "Selected Location"),
        icon: BitmapDescriptor.defaultMarker,
      );
      _getAddressFromLatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place!.street} ${place!.subLocality} ${place!.locality}, ${place!.postalCode},${place!.administrativeArea!} ,${place!.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;
  }

  void _onCameraIdle() {
    _updateMarker(_currentCenter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _initialCenter!,
                    zoom: 11.0,
                  ),
                  //  markers: _centerMarker != null ? {_centerMarker!} : {},
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                const Center(
                  child: Icon(Icons.location_on, size: 50, color: Colors.red),
                ),
              ],
            ),
          ),
          if (_currentAddress != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Selected Address: $_currentAddress',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                appVariable.turf_LocationController.value.text =
                    _currentAddress!;
                Navigator.pop(context);
                appVariable.lat.value = _currentCenter.latitude.toString();
                appVariable.lng.value = _currentCenter.longitude.toString();
                _updateMarker(_currentCenter);
                appVariable.street.value = place!.street!;
                appVariable.country.value = place!.country!;
                appVariable.subLocality.value = place!.subLocality!;
                appVariable.locality.value = place!.locality!;
                appVariable.postalCode.value = place!.postalCode!;
                appVariable.state.value = place!.administrativeArea!;
                appVariable.streetController.value.text = place!.street!;
                appVariable.countryController.value.text = place!.country!;
                appVariable.subLocalityController.value.text =
                    place!.subLocality!;
                appVariable.localityController.value.text = place!.locality!;
                appVariable.postalCodeController.value.text =
                    place!.postalCode!;
                appVariable.stateController.value.text =
                    place!.administrativeArea!;


                       variableAdd.turf_LocationController.value.text =
                    _currentAddress!;
             
                variableAdd.lat.value = _currentCenter.latitude.toString();
                variableAdd.lng.value = _currentCenter.longitude.toString();
               
                variableAdd.street.value = place!.street!;
                variableAdd.country.value = place!.country!;
                variableAdd.subLocality.value = place!.subLocality!;
                variableAdd.locality.value = place!.locality!;
                variableAdd.postalCode.value = place!.postalCode!;
                variableAdd.state.value = place!.administrativeArea!;
                variableAdd.streetController.value.text = place!.street!;
                variableAdd.countryController.value.text = place!.country!;
                variableAdd.subLocalityController.value.text =
                    place!.subLocality!;
                variableAdd.localityController.value.text = place!.locality!;
                variableAdd.postalCodeController.value.text =
                    place!.postalCode!;
                variableAdd.stateController.value.text =
                    place!.administrativeArea!;
              },
              child: const Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
