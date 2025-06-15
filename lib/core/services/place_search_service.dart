import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/maps/map_select_location/models/place_search_result_model.dart';

class PlaceSearchService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  static const String _apiKey = ConstApi.googleMapsApiKey; // Replace with your actual APIs key

  // Search for places using Google Places APIs
  static Future<List<PlaceSearchResult>> searchPlaces(String query) async {
    try {
      final response = await sl<DioClient>().get(
        '$_baseUrl/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final List<dynamic> predictions = response.data['predictions'];
        return predictions.map((prediction) => PlaceSearchResult.fromJson(prediction)).toList();
      }

      // Handle APIs errors
      if (response.statusCode == 200 && response.data['status'] != 'OK') {
        throw Exception('Google APIs error: ${response.data['status']}');
      }

      throw Exception('Network error: ${response.statusCode}');
    } catch (e) {
      // Better error handling
      print('Error searching places: $e');
      throw Exception('Failed to search places');
    }
  }

  // Get place details to get the latitude and longitude
  static Future<LatLng> getPlaceDetails(String placeId) async {
    try {
      final response = await sl<DioClient>().get(
        '$_baseUrl/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }

      // Handle APIs errors
      if (response.statusCode == 200 && response.data['status'] != 'OK') {
        throw Exception('Google API error: ${response.data['status']}');
      }

      throw Exception('Network error: ${response.statusCode}');
    } catch (e) {
      // Better error handling
      print('Error getting place details: $e');
      throw Exception('Failed to get location details');
    }
  }
}
