import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/core/APIs/api_auth_services.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/profile/edit_profile/models/edit_profile_params.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({required this.user}) : super(const EditProfileInitial()) {
    editedUser = user;
    firstNameController.text = user.firstName;
    secondNameController.text = user.lastName;
    phoneNumberController.text = user.phoneNumber;
    locationController.text = user.address;
    emailController.text = user.email;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File? profilePic;
  late UserModel user, editedUser;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode secondNameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  Future<void> selectProfilePic() async {
    final img = await pickImageFromGallery();
    if (profilePic == img) return;
    profilePic = img;
    emit(const EditProfileUpdate(isChanged: true));
  }

  void clearProfilePic() {
    profilePic = null;
    editedUser = editedUser.copyWith(clearProfilePic: true);
    emit(const EditProfileUpdate(isChanged: true));
  }

  File? getProfilePic() {
    return profilePic;
  }

  void _unfocus() async {
    firstNameFocusNode.unfocus();
    secondNameFocusNode.unfocus();
    phoneNumberFocusNode.unfocus();
    locationFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  Future<void> save() async {
    _unfocus();
    if (formKey.currentState!.validate() == false) return;

    EasyLoading.show();
    await ApiAuthServices.editProfile(
      editProfileParams: EditProfileParams(
        firstName: editedUser.firstName,
        secondName: editedUser.lastName,
        email: editedUser.email,
        phoneNumber: editedUser.phoneNumber,
        longitude: editedUser.location.longitude,
        latitude: editedUser.location.latitude,
        address: editedUser.address,
        profilePic: profilePic,
        removedPicture: (user.profilePictureURL != editedUser.profilePictureURL),
      ),
    ).then((res) {
      res.fold(
        (error) => emit(EditProfileFailure(error: error, isChanged: state.isChanged)),
        (r) {
          user = editedUser;
          emit(const EditProfileSuccess(isChanged: false));
        },
      );
    });

    EasyLoading.dismiss();
  }

  void checkChanges() {
    editedUser = editedUser.copyWith(
      firstName: firstNameController.text,
      lastName: secondNameController.text,
      phoneNumber: phoneNumberController.text,
      address: locationController.text,
    );

    final bool changed = (user != editedUser) || (profilePic != null);
    emit(EditProfileUpdate(isChanged: changed));
  }

  // void setUserModel(UserModel userModel) {
  //   user = editedUser = userModel;
  //   firstNameController.text = userModel.firstName;
  //   secondNameController.text = userModel.lastName;
  //   phoneNumberController.text = userModel.phoneNumber;
  //   locationController.text = userModel.address;
  // }

  void goToHome(BuildContext context) {
    _unfocus();
    Navigator.pushReplacementNamed(context, PageRouteNames.home);
  }

  void goToMapSelectLocation(BuildContext context) async {
    _unfocus();
    final MapSelectLocationArgs args = MapSelectLocationArgs(
      location: editedUser.location,
      address: editedUser.address,
    );

    final retArgs = await Navigator.pushNamed(
      context,
      PageRouteNames.mapSelectLocation,
      arguments: args,
    ) as MapSelectLocationArgs?;

    if (retArgs == null) return;

    print("Selected location: ${retArgs.address}");
    locationController.text = retArgs.address;
    editedUser = editedUser.copyWith(
      location: retArgs.location,
      address: retArgs.address,
    );

    emit(const EditProfileUpdate(isChanged: true));
  }

  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openEndDrawer();
    }
  }

  void goBack(BuildContext context) {
    _unfocus();
    Navigator.pop(context);
  }

  @override
  Future<void> close() async {
    firstNameController.dispose();
    secondNameController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    passwordController.dispose();
    firstNameFocusNode.dispose();
    secondNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    locationFocusNode.dispose();
    passwordFocusNode.dispose();
    super.close();
  }
}
