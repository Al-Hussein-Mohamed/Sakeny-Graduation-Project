part of 'compare_cubit.dart';

sealed class CompareState extends Equatable {
  const CompareState();

  @override
  List<Object> get props => [];
}

final class CompareInitial extends CompareState {}

final class CompareLoaded extends CompareState {
  const CompareLoaded({required this.posts});

  final List<PostModel> posts;

  @override
  List<Object> get props => [posts];
}
