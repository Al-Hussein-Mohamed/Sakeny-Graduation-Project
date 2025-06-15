part of 'map_overlay_controls_cubit.dart';

@immutable
sealed class MapOverlayControlsState extends Equatable {
  const MapOverlayControlsState({
    required this.address,
  });

  final String? address;
}

final class MapOverlayControlsInitial extends MapOverlayControlsState {
  const MapOverlayControlsInitial() : super(address: null);

  @override
  List<Object?> get props => [super.address];
}

final class MapOverlayControlsLoading extends MapOverlayControlsState {
  const MapOverlayControlsLoading({required super.address});

  @override
  List<Object?> get props => [super.address];
}

final class MapOverlayControlsLoaded extends MapOverlayControlsState {
  const MapOverlayControlsLoaded({required super.address});

  @override
  List<Object?> get props => [super.address];
}

final class MapOverlayControlsError extends MapOverlayControlsState {
  const MapOverlayControlsError({
    required super.address,
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [address, message];
}
