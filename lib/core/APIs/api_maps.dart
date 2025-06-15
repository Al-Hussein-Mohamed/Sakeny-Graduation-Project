import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/maps/map_select_location/models/place_search_result_model.dart';

class ApiMaps {
  ApiMaps._();

  static final DioClient _dio = sl<DioClient>();

  static Future<List<PlaceSearchResult>> autoComplete(String query) async {
    try {
      final response = await _dio.get(
        '${ConstApi.googleMapsBaseUrl}/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': ConstApi.googleMapsApiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final List<dynamic> predictions = response.data['predictions'];
        return predictions.map((prediction) => PlaceSearchResult.fromJson(prediction)).toList();
      }

      if (response.statusCode == 200 && response.data['status'] != 'OK') {
        throw Exception('Google APIs error: ${response.data['status']}');
      }

      throw Exception('Network error: ${response.statusCode}');
    } catch (e) {
      log('Error searching places: $e');
      throw Exception('Failed to search places');
    }
  }

  static Future<LatLng> getPlaceLocation(String placeId) async {
    try {
      final response = await sl<DioClient>().get(
        '${ConstApi.googleMapsBaseUrl}/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': ConstApi.googleMapsApiKey,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }

      if (response.statusCode == 200 && response.data['status'] != 'OK') {
        throw Exception('Google API error: ${response.data['status']}');
      }

      throw Exception('Network error: ${response.statusCode}');
    } catch (e) {
      log('Error getting place details: $e');
      throw Exception('Failed to get location details');
    }
  }

  static Future<String?> reverseGeoCoding(double lat, double lng) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng, localeIdentifier: 'ar');
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // Uber-style: street, sublocality/neighborhood, city, state, country (no codes), all in Arabic
        final List<String?> parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ];

        for (int i = 0; i < parts.length; i++) {
          print("$i, ${parts[i]}");
        }
        // Remove null, empty, and code-like parts (e.g., plus codes)
        final address = parts
            .where((e) => e != null && e.trim().isNotEmpty)
            .where((e) => !RegExp(r'^[A-Z0-9+]{6,}$').hasMatch(e!))
            .toSet() // Remove duplicates
            .join(', ');
        return address.isNotEmpty ? address : null;
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
    return null;
  }

  static Future<String> getAddressFromLatLng(LatLng location) async {
    // try {
    //   final String? address = await reverseGeoCoding(location.latitude, location.longitude);
    //   print(address);
    //   if (address != null && address.isNotEmpty) {
    //     return address;
    //   }
    // } catch (e) {
    //   log('Error in reverse geocoding: $e');
    // }

    try {
      final response = await sl<DioClient>().get(
        '${ConstApi.googleMapsBaseUrl}/geocode/json',
        queryParameters: {
          'latlng': '${location.latitude},${location.longitude}',
          'key': ConstApi.googleMapsApiKey,
          'language': 'ar',
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        if (response.data['results'].isNotEmpty) {
          final components = response.data['results'][0]['address_components'] as List;

          final Map<String, String> parts = {};

          for (final c in components) {
            final types = List<String>.from(c['types']);
            for (final type in types) {
              if (!parts.containsKey(type)) {
                parts[type] = c['long_name'];
              }
            }
          }

          // Compose formatted address (you can adjust this order/format)
          final street = [parts['street_number'], parts['route']]
              .where((e) => e != null && e.isNotEmpty)
              .join(' ');

          final city = parts['locality'] ?? parts['administrative_area_level_2'];
          final state = parts['administrative_area_level_1'];
          final country = parts['country'];

          final formatted = [
            if (street.isNotEmpty) street,
            if (city != null && city.isNotEmpty) city,
            if (state != null && state.isNotEmpty) state,
            if (country != null && country.isNotEmpty) country,
          ].join(', ');

          return formatted.isNotEmpty ? formatted : 'Address not found';
        } else {
          return 'Address not found';
        }
      }

      if (response.statusCode == 200 && response.data['status'] != 'OK') {
        throw Exception('Google APIs error: ${response.data['status']}');
      }

      throw Exception('Network error: ${response.statusCode}');
    } catch (e) {
      log('Error getting address: $e');
      return 'Location';
    }
  }
}
