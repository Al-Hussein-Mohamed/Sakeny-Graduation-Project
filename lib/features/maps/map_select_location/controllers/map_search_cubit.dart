import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/APIs/api_maps.dart';
import 'package:sakeny/features/maps/map_select_location/models/place_search_result_model.dart';

part 'map_search_state.dart';

class MapSearchCubit extends Cubit<MapSearchState> {
  MapSearchCubit() : super(const MapSearchInitial()) {
    searchFocusNode.addListener(
      () {
        final List<PlaceSearchResult> results =
            state is MapSearchLoaded ? (state as MapSearchLoaded).searchResults : [];
        if (searchFocusNode.hasFocus) {
          emit(MapSearchLoaded(hasFocus: true, searchResults: results));
        } else {
          emit(MapSearchLoaded(hasFocus: false, searchResults: results));
        }
      },
    );
  }

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  void unFocusSearch() {
    searchFocusNode.unfocus();
    emit(
      MapSearchLoaded(
        hasFocus: false,
        searchResults: state is MapSearchLoaded ? (state as MapSearchLoaded).searchResults : [],
      ),
    );
  }

  void clearSearch() {
    searchController.clear();
    emit(MapSearchLoaded(hasFocus: state.hasFocus, searchResults: const []));
  }

  void autoComplete(String value) async {
    if (value.isEmpty) {
      emit(MapSearchLoaded(hasFocus: state.hasFocus, searchResults: const []));
      return;
    }
    try {
      final List<PlaceSearchResult> results = await ApiMaps.autoComplete(value);
      if (searchController.text == value) {
        emit(MapSearchLoaded(hasFocus: state.hasFocus, searchResults: results));
      }
    } catch (e) {
      emit(MapSearchError(hasFocus: state.hasFocus, message: e.toString()));
      return;
    }
  }

  Future<LatLng> getLatLngFromPlaceId(String placeId) async {
    try {
      final LatLng latLng = await ApiMaps.getPlaceLocation(placeId);
      return latLng;
    } catch (e) {
      emit(MapSearchError(hasFocus: state.hasFocus, message: e.toString()));
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    searchController.dispose();
    searchFocusNode.dispose();
    super.close();
  }
}
