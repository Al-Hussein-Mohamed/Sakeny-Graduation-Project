import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';

part 'compare_state.dart';

class CompareCubit extends Cubit<CompareState> {
  CompareCubit() : super(CompareInitial());

  final scaffoldKeyCompare = GlobalKey<ScaffoldState>();
  List<PostModel> selectedPosts = [];

  void openDrawerCompare() {
    if (scaffoldKeyCompare.currentState != null) {
      scaffoldKeyCompare.currentState!.openEndDrawer();
    }
  }

  void closeDrawerCompare() {
    if (scaffoldKeyCompare.currentState != null) {
      scaffoldKeyCompare.currentState!.closeEndDrawer();
    }
  }

  void setPostsToCompare(List<PostModel> posts) {
    selectedPosts = posts;
    emit(CompareLoaded(posts: posts));
  }

  void clearComparison() {
    selectedPosts.clear();
    emit(CompareInitial());
  }
}
