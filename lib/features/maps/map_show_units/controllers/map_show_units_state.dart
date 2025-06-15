part of 'map_show_units_cubit.dart';

@immutable
sealed class MapShowUnitsState extends Equatable {
  const MapShowUnitsState();
}

final class MapShowUnitsLoading extends MapShowUnitsState {
  const MapShowUnitsLoading();

  @override
  List<Object?> get props => [];
}

final class MapShowUnitsLoaded extends MapShowUnitsState {
  MapShowUnitsLoaded({required this.posts, required this.onMapTap}) {
    markers = posts
        .map(
          (post) => Marker(
            markerId: MarkerId(post.unit.unitId.toString()),
            position: post.unit.location,
            onTap: () => onMapTap(post.unit, posts.indexOf(post)),
          ),
        )
        .toSet();
  }

  final List<PostModel> posts;
  late final Set<Marker> markers;
  final void Function(UnitModel unit, int index) onMapTap;

  @override
  List<Object?> get props => [posts];
}

final class MapShowUnitsError extends MapShowUnitsState {
  const MapShowUnitsError({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
