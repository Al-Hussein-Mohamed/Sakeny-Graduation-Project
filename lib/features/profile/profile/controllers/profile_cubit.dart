import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({required this.isEditing});

  final bool isEditing;

  @override
  List<Object?> get props => [isEditing];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(isEditing: false));

  static ProfileCubit of(BuildContext context) => context.read<ProfileCubit>();

  void toggleEditing() {
    emit(ProfileState(isEditing: !state.isEditing));
  }

  void setEditing(bool isEditing) {
    emit(ProfileState(isEditing: isEditing));
  }
}
