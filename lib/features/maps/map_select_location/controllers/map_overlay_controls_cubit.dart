import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/APIs/api_maps.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/maps/map_select_location/screens/map_select_location_screen.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

part 'map_overlay_controls_state.dart';

class MapOverlayControlsCubit extends Cubit<MapOverlayControlsState> {
  MapOverlayControlsCubit(this.mapArgs) : super(const MapOverlayControlsInitial()) {
    if (mapArgs != null) {
      emit(MapOverlayControlsLoaded(address: mapArgs!.address));
    }
  }

  final MapSelectLocationArgs? mapArgs;

  void setPlaceTitle(String title) {
    emit(MapOverlayControlsLoaded(address: title));
  }

  void getPlaceTitle(LatLng location) async {
    emit(MapOverlayControlsLoading(address: state.address));
    try {
      final String address = await ApiMaps.getAddressFromLatLng(location);
      emit(MapOverlayControlsLoaded(address: address));
    } catch (e) {
      emit(MapOverlayControlsError(address: state.address, message: e.toString()));
    }
  }

  Future<MapSelectLocationArgs?> getCurrentPosition(BuildContext context) async {
    final bool permissionGranted = await requestLocationPermission(context);
    if (!permissionGranted) return null;

    emit(MapOverlayControlsLoading(address: state.address));

    late final LatLng currentLocation;

    try {
      final position = await Geolocator.getCurrentPosition();
      currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      emit(MapOverlayControlsError(
        address: state.address,
        message: "Error getting current location: $e",
      ));

      return null;
    }

    late final String address;
    try {
      address = await ApiMaps.getAddressFromLatLng(currentLocation);
      emit(MapOverlayControlsLoaded(address: address));
    } catch (e) {
      emit(MapOverlayControlsError(
        address: state.address,
        message: "Error getting address from coordinates: $e",
      ));

      return null;
    }

    return MapSelectLocationArgs(location: currentLocation, address: address);
  }

  Future<bool> askGpsService(BuildContext context) async {
    if (!context.mounted) return false;
    final S lang = S.of(context);

    final bool isServiceEnabled = await showDialog(
      context: context,
      builder: (context) => const EnableGpsDialog(),
    );

    if (!isServiceEnabled) {
      ToastificationService.showGlobalToast(
        lang.mapGpsServiceIsDisabledTitle,
        lang.mapGpsServiceIsDisabledMessage,
        ToastificationType.error,
      );
      return false;
    }

    return true;
  }

  Future<bool> requestLocationPermission(BuildContext context) async {
    final S lang = S.of(context);

    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!context.mounted) return false;
      final bool newServiceState = await askGpsService(context);
      if (!newServiceState) return false;
    }

    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse) return true;
    if (permission == LocationPermission.always) return true;

    final newPermission = await Geolocator.requestPermission();
    if (newPermission == LocationPermission.whileInUse) return true;
    if (newPermission == LocationPermission.always) return true;

    ToastificationService.showGlobalToast(
      lang.mapLocationPermissionDeniedTitle,
      lang.mapLocationPermissionDeniedMessage,
      ToastificationType.error,
    );

    return false;
  }
}
