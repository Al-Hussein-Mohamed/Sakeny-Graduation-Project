import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/services/service_locator.dart';

class GeocodingHelper {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  static const String _apiKey = ConstApi.googleMapsApiKey; // Replace with your actual APIs key

  // Convert coordinates to address
  static Future<String> getAddressFromLatLng(LatLng location) async {
    try {
      final response = await sl<DioClient>().get(
        '$_baseUrl/geocode/json',
        queryParameters: {
          'latlng': '${location.latitude},${location.longitude}',
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        if (response.data['results'].isNotEmpty) {
          return response.data['results'][0]['formatted_address'];
        } else {
          return 'Address not found';
        }
      }

      // Handle APIs errors
      if (response.statusCode == 200 && response.data['status'] != 'OK') {
        throw Exception('Google APIs error: ${response.data['status']}');
      }

      throw Exception('Network error: ${response.statusCode}');
    } catch (e) {
      // Better error handling
      print('Error getting address: $e');
      return 'Location';
    }
  }
}
