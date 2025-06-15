import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectLocationArgs {
  const MapSelectLocationArgs({
    required this.location,
    required this.address,
  });

  final LatLng location;
  final String address;
}
