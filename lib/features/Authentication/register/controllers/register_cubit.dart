import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/APIs/api_auth_services.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/Authentication/register/models/register_req_params.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? profilePic;
  LatLng? selectedLocation;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void goToLogin(BuildContext context, {bool sendData = false}) {
    final Map<String, dynamic> args = {};
    if (sendData) {
      args["email"] = emailController.text;
      args["password"] = passwordController.text;
      args["showVerifyEmailBanner"] = true;
    }
    Navigator.pop(context, args);
  }

  void goToMapSelectLocation(BuildContext context) async {
    final MapSelectLocationArgs? args = selectedLocation == null
        ? null
        : MapSelectLocationArgs(
            location: selectedLocation!,
            address: locationController.text,
          );

    final retArgs =
        await Navigator.pushNamed(context, PageRouteNames.mapSelectLocation, arguments: args)
            as MapSelectLocationArgs?;

    if (retArgs == null) return;
    selectedLocation = retArgs.location;
    locationController.text = retArgs.address;
  }

  File? getProfilePic() {
    return profilePic;
  }

  void clearProfilePic() {
    profilePic = null;
    emit(RegisterInitial());
  }

  Future<void> selectProfilePic() async {
    final img = await pickImageFromGallery();
    if (profilePic == img) return;
    profilePic = img;
    emit(RegisterInitial());
  }

  void register() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        emit(RegisterFailed(errorMessage: "Passwords do not match"));
        return;
      }

      EasyLoading.show();
      emit(RegisterLoading());
      ApiAuthServices.register(
        registerReqParams: RegisterReqParams(
          firstName: firstNameController.text.trim(),
          secondName: secondNameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          latitude: selectedLocation!.latitude,
          longitude: selectedLocation!.longitude,
          address: locationController.text.trim(),
          profilePic: profilePic,
        ),
      ).then((response) {
        response.fold(
          (error) {
            EasyLoading.dismiss();
            emit(RegisterFailed(errorMessage: error));
          },
          (data) {
            EasyLoading.dismiss();
            emit(RegisterSuccess());
          },
        );
      });
    } else {
      emit(RegisterInitial());
    }
  }
}
