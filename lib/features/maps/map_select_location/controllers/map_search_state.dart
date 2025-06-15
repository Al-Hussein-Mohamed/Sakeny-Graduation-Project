part of 'map_search_cubit.dart';

@immutable
sealed class MapSearchState extends Equatable {
  const MapSearchState({required this.hasFocus});

  final bool hasFocus;
}

final class MapSearchInitial extends MapSearchState {
  const MapSearchInitial() : super(hasFocus: false);

  @override
  List<Object?> get props => [super.hasFocus];
}

final class MapSearchLoaded extends MapSearchState {
  const MapSearchLoaded({
    required super.hasFocus,
    required this.searchResults,
  });

  final List<PlaceSearchResult> searchResults;

  @override
  List<Object?> get props => [searchResults, super.hasFocus];
}

final class MapSearchError extends MapSearchState {
  const MapSearchError({
    required super.hasFocus,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message, super.hasFocus];
}
