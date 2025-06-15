import 'package:sakeny/features/filters/models/filters_parameters_model.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';

class MapShowUnitsArgs {
  const MapShowUnitsArgs({
    this.post,
    this.searchQuery,
    this.filters,
  });

  final PostModel? post;
  final String? searchQuery;
  final FiltersParametersModel? filters;
}
