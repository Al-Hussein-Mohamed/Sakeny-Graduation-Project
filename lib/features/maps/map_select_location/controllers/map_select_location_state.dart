part of 'map_select_location_cubit.dart';

@immutable
abstract class MapSelectLocationState extends Equatable {
  const MapSelectLocationState({
    required this.selectedLocation,
    required this.permissionGranted,
    required this.isMapReady,
    required this.address,
  });

  final bool permissionGranted;
  final bool isMapReady;
  final LatLng? selectedLocation;
  final String? address;
}

class MapSelectLocationInitial extends MapSelectLocationState {
  const MapSelectLocationInitial()
      : super(
          permissionGranted: false,
          isMapReady: false,
          selectedLocation: null,
          address: null,
        );

  @override
  List<Object?> get props => [
        permissionGranted,
        isMapReady,
        selectedLocation,
        address,
      ];
}

class MapSelectLocationLoading extends MapSelectLocationState {
  const MapSelectLocationLoading({
    required super.selectedLocation,
    required super.permissionGranted,
    required super.isMapReady,
    super.address,
  });

  @override
  List<Object?> get props => [
        permissionGranted,
        isMapReady,
        selectedLocation,
        address,
      ];
}

class MapSelectLocationSearching extends MapSelectLocationState {
  const MapSelectLocationSearching({
    required super.selectedLocation,
    required super.permissionGranted,
    required super.isMapReady,
    super.address,
  });

  @override
  List<Object?> get props => [
        permissionGranted,
        isMapReady,
        selectedLocation,
        address,
      ];
}

class MapSelectLocationLoaded extends MapSelectLocationState {
  const MapSelectLocationLoaded({
    required super.selectedLocation,
    required super.permissionGranted,
    required super.isMapReady,
    super.address,
  });

  @override
  List<Object?> get props => [
        permissionGranted,
        isMapReady,
        selectedLocation,
        address,
      ];
}

class MapSelectLocationError extends MapSelectLocationState {
  const MapSelectLocationError({
    required this.message,
    required super.selectedLocation,
    required super.permissionGranted,
    required super.isMapReady,
    super.address,
  });

  final String message;

  @override
  List<Object?> get props => [
        permissionGranted,
        isMapReady,
        selectedLocation,
        address,
        message,
      ];
}
