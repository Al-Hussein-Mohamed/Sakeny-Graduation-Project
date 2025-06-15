import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/APIs/api_post.dart';
import 'package:sakeny/features/filters/models/filters_parameters_model.dart';
import 'package:sakeny/features/maps/map_show_units/controllers/map_show_units_config.dart';
import 'package:sakeny/features/maps/map_show_units/models/map_show_units_args.dart';
import 'package:sakeny/features/post/posts/controllers/post_synchronizer.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';

part 'map_show_units_state.dart';

class MapShowUnitsCubit extends Cubit<MapShowUnitsState> {
  MapShowUnitsCubit({this.args}) : super(const MapShowUnitsLoading()) {
    init();
  }

  void init() async {
    if (args == null) {
      emit(const MapShowUnitsError(error: "Invalid arguments"));
      return;
    }

    late final List<PostModel> posts;
    bool fetchPosts = false;

    if (args?.post != null) {
      dev.log("fetched by post");
      fetchPosts = true;
      posts = [args!.post!];
    }

    if (args?.filters != null) {
      final List<PostModel>? res = await getPostsByFilter(args!.filters!);
      if (res == null) {
        dev.log("did not fetch any units by filters");
        return;
      }

      dev.log("fetched by filters");
      fetchPosts = true;
      posts = res;
    }

    if (args?.searchQuery != null) {
      final List<PostModel>? res = await searchByTerm(args!.searchQuery!);
      print(res);
      print(res?.length);
      if (res == null) {
        dev.log("did not fetch any units by search");
        return;
      }
      dev.log("fetched by search");
      fetchPosts = true;
      posts = res;
    }

    if (!fetchPosts) {
      dev.log("did not fetch any units");
      emit(const MapShowUnitsError(error: "Null Arguments"));
      return;
    }

    emit(MapShowUnitsLoaded(
      posts: posts,
      onMapTap: (UnitModel unit, int index) => scrollToUnit(index),
    ));
  }

  static MapShowUnitsCubit of(BuildContext context) => context.read<MapShowUnitsCubit>();

  final MapShowUnitsArgs? args;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final DraggableScrollableController sheetScrollController = DraggableScrollableController();
  final ScrollController unitsScrollController = ScrollController();
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  void collapseSheet() {
    sheetScrollController.animateTo(
      MapShowUnitsConfig.minChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void locateUnitOnMap(LatLng location, int index) async {
    final GoogleMapController controller = await mapController.future;

    scrollToUnit(index);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 18,
        ),
      ),
    );
  }

  void scrollToUnit(int index) {
    final double offset =
        index * (MapShowUnitsConfig.uintItemHeight + 2 * MapShowUnitsConfig.unitItemVerticalMargin);

    unitsScrollController.animateTo(
      min(offset, unitsScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<List<PostModel>?> getPostsByFilter(FiltersParametersModel filter) async {
    emit(const MapShowUnitsLoading());

    try {
      final response = await ApiPost.getPostsByFilter(filter: filter);
      return response;
    } catch (e) {
      emit(MapShowUnitsError(error: e.toString()));
      return null;
    }
  }

  Future<List<PostModel>?> searchByTerm(String term) async {
    emit(const MapShowUnitsLoading());

    final response = await ApiPost.searchByTerm(
      term: term,
      pageIndex: 1,
      pageSize: 50,
    );

    List<PostModel>? posts;
    response.fold(
      (error) {
        emit(MapShowUnitsError(error: e.toString()));
      },
      (newPosts) {
        posts = newPosts;
      },
    );

    return posts;
  }

  void addPostToFavorites({required int index}) async {
    if (state is! MapShowUnitsLoaded) return;

    final curState = state as MapShowUnitsLoaded;
    if (curState.posts[index].isFavorite) return;

    await ApiPost.addPostToFavorites(postId: curState.posts[index].postId).then((res) {
      res.fold((error) {
        emit(MapShowUnitsError(error: error));
      }, (r) {
        final updatedPosts = List<PostModel>.from(curState.posts);
        updatedPosts[index] = updatedPosts[index].copyWith(isFavorite: true);
        emit(MapShowUnitsLoaded(
          posts: updatedPosts,
          onMapTap: (UnitModel unit, int index) => scrollToUnit(index),
        ));

        // Synchronize with other instances
        PostSynchronizer.setFavoriteStatus(
          curState.posts[index].postId.toString(),
          true,
        );
      });
    });
  }

  void removePostFromFavorites({required int index}) async {
    if (state is! MapShowUnitsLoaded) return;

    final curState = state as MapShowUnitsLoaded;
    if (!curState.posts[index].isFavorite) return;

    await ApiPost.removePostFromFavorites(postId: curState.posts[index].postId).then((res) {
      res.fold((error) {
        emit(MapShowUnitsError(error: error));
      }, (r) {
        final updatedPosts = List<PostModel>.from(curState.posts);
        updatedPosts[index] = updatedPosts[index].copyWith(isFavorite: false);
        emit(MapShowUnitsLoaded(
          posts: updatedPosts,
          onMapTap: (UnitModel unit, int index) => scrollToUnit(index),
        ));

        // Synchronize with other instances
        PostSynchronizer.setFavoriteStatus(
          curState.posts[index].postId.toString(),
          false,
        );
      });
    });
  }
}
