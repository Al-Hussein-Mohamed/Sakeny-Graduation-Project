part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {
  const EditProfileState({
    required this.isChanged,
  });

  final bool isChanged;
}

final class EditProfileInitial extends EditProfileState {
  const EditProfileInitial() : super(isChanged: false);
}

final class EditProfileUpdate extends EditProfileState {
  const EditProfileUpdate({required super.isChanged});
}

final class EditProfileLoading extends EditProfileState {
  const EditProfileLoading({required super.isChanged});
}

final class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess({required super.isChanged});
}

final class EditProfileFailure extends EditProfileState {
  const EditProfileFailure({required super.isChanged, required this.error});

  final String error;
}
