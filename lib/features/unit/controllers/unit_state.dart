part of 'unit_cubit.dart';

@immutable
sealed class UnitState extends Equatable {
  const UnitState();
}

final class UnitLoading extends UnitState {
  const UnitLoading();

  @override
  List<Object?> get props => [];
}

final class UnitLoaded extends UnitState {
  const UnitLoaded({
    required this.unitModel,
  });

  final UnitModel unitModel;

  @override
  List<Object?> get props => [unitModel];
}
