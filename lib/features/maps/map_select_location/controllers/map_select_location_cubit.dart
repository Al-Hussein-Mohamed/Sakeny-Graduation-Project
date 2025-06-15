import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/APIs/api_maps.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/maps/map_select_location/models/place_search_result_model.dart';

part 'map_select_location_state.dart';

class MapSelectLocationCubit extends Cubit<MapSelectLocationState> {
  MapSelectLocationCubit(this.mapArgs) : super(const MapSelectLocationInitial()) {
    setUp();
  }

  void setUp() async {
    initialPosition = CameraPosition(
      target: mapArgs?.location ?? const LatLng(26.563842557729348, 31.68609748611687),
      zoom: 14.0,
    );

    await Future.delayed(ConstConfig.navigationDuration);
    showMap = true;
    emit(MapSelectLocationLoaded(
      selectedLocation: mapArgs?.location ?? state.selectedLocation,
      address: mapArgs?.address ?? state.address,
      permissionGranted: state.permissionGranted,
      isMapReady: state.isMapReady,
    ));
  }

  final MapSelectLocationArgs? mapArgs;
  bool showMap = false;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  late CameraPosition initialPosition;

  void initializeMap(GoogleMapController controller) {
    _mapController = controller;
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }

    emit(
      MapSelectLocationLoaded(
        selectedLocation: state.selectedLocation,
        permissionGranted: state.permissionGranted,
        isMapReady: true,
        address: state.address,
      ),
    );

    // checkLocationPermission();
  }

  void getPlaceTitle(LatLng location) async {
    emit(MapSelectLocationLoading(
      selectedLocation: location,
      permissionGranted: state.permissionGranted,
      isMapReady: true,
      address: state.address,
    ));

    late String? address;
    try {
      address = await ApiMaps.getAddressFromLatLng(location);
    } catch (e) {
      address = null;
    }

    emit(MapSelectLocationLoaded(
      selectedLocation: location,
      permissionGranted: state.permissionGranted,
      isMapReady: true,
      address: address,
    ));
  }

  void setSelectedLocation(LatLng location) {
    emit(
      MapSelectLocationSearching(
        selectedLocation: location,
        permissionGranted: state.permissionGranted,
        isMapReady: true,
        address: state.address,
      ),
    );

    getPlaceTitle(location);
  }

  Future<void> animateToLocationAndMark({required LatLng location, String? address}) async {
    if (_mapController == null) return;

    try {
      // First animate camera to position
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: location,
            zoom: 15.0,
          ),
        ),
      );

      print("Animate to location: $address");
      address ??= await ApiMaps.getAddressFromLatLng(location);
      print("Animate to location: $address");

      emit(
        MapSelectLocationLoaded(
          selectedLocation: location,
          permissionGranted: state.permissionGranted,
          isMapReady: true,
          address: address,
        ),
      );
    } catch (e) {
      emit(
        MapSelectLocationError(
          message: "Error setting location: $e",
          selectedLocation: state.selectedLocation,
          permissionGranted: state.permissionGranted,
          isMapReady: true,
          address: state.address,
        ),
      );
    }
  }

  Future<void> selectPlaceFromResults(PlaceSearchResult place) async {
    emit(
      MapSelectLocationLoading(
        selectedLocation: state.selectedLocation,
        permissionGranted: state.permissionGranted,
        isMapReady: true,
        address: state.address,
      ),
    );

    try {
      final location = await ApiMaps.getPlaceLocation(place.placeId);

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: location,
              zoom: 16.0,
            ),
          ),
        );
      }

      // Update with new location and address
      emit(
        MapSelectLocationLoaded(
          selectedLocation: location,
          permissionGranted: state.permissionGranted,
          isMapReady: true,
          address: place.description,
        ),
      );
    } catch (e) {
      emit(
        MapSelectLocationError(
          message: "Failed to get place details: $e",
          selectedLocation: state.selectedLocation,
          permissionGranted: state.permissionGranted,
          isMapReady: true,
          address: state.address,
        ),
      );
    }
  }

  // -----------------------> Select Button <---------------------------
  void selectLocation(BuildContext context) {
    if (state.selectedLocation == null) return;
    if (state.address == null) return;

    final MapSelectLocationArgs args = MapSelectLocationArgs(
      location: state.selectedLocation!,
      address: state.address!,
    );

    Navigator.pop(context, args);
  }

  @override
  Future<void> close() {
    _mapController?.dispose();
    _controller.future.then((controller) => controller.dispose());
    return super.close();
  }
}
