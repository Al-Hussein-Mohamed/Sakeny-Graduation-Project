import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sakeny/core/constants/const_api.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/Authentication/forget_password/models/change_password_params.dart';
import 'package:sakeny/features/Authentication/forget_password/models/verify_otp_params.dart';
import 'package:sakeny/features/Authentication/login/models/sign_in_params.dart';
import 'package:sakeny/features/Authentication/register/models/register_req_params.dart';
import 'package:sakeny/features/profile/edit_profile/models/edit_profile_params.dart';

class ApiAuthServices {
  static final _dioClient = sl<DioClient>();
  static final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    serverClientId: "441420564337-ekd1fsn1tb833cl2b18i1u9la7at4ini.apps.googleusercontent.com",
  );

  // register
  static Future<Either> register({required RegisterReqParams registerReqParams}) async {
    try {
      final response = await sl<DioClient>().post(
        ConstApi.registerUrl,
        data: FormData.fromMap(registerReqParams.toJson()),
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(
          "Error: ${response.statusCode}, msg: ${response.statusMessage}, data: ${response.data}",
        );
      }
    } on DioException catch (e) {
      return Left(
        "Error: ${e.response?.data}",
      );
    }
  }

  // login
  static Future<Either> signIn({required SignInParams signInParams}) async {
    try {
      final response = await sl<DioClient>().post(
        ConstApi.signInUrl,
        data: signInParams.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(response.data["msg"]);
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  // Forget Password
  static Future<Either> forgetPassword({required String email}) async {
    try {
      final response = await sl<DioClient>().post(
        ConstApi.forgetPasswordUrl,
        data: '"$email"',
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(
          "Error: ${response.statusCode}, msg: ${response.statusMessage}, data: ${response.data}",
        );
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  // verify OTP
  static Future<Either> verifyOtp({required VerifyOtpParams verifyOtpParams}) async {
    try {
      final response = await sl<DioClient>().post(
        ConstApi.verifyOtpUrl,
        data: verifyOtpParams.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(
          "Error: ${response.statusCode}, msg: ${response.statusMessage}, data: ${response.data}",
        );
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  //Change Password
  static Future<Either> changePassword({required ChangePasswordParams changePasswordParams}) async {
    try {
      final response = await sl<DioClient>().post(
        ConstApi.changePasswordUrl,
        data: changePasswordParams.toJson(),
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(
          "Error: ${response.statusCode}, msg: ${response.statusMessage}, data: ${response.data}",
        );
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  // Edit Profile
  static Future<Either> editProfile({required EditProfileParams editProfileParams}) async {
    try {
      final response = await sl<DioClient>().put(
        ConstApi.editProfileUrl,
        options: withAuth(),
        data: FormData.fromMap(editProfileParams.toJson()),
      );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return Left(
          "Error: ${response.statusCode}, msg: ${response.statusMessage}, data: ${response.data}",
        );
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  // Google Sign-In
  static Future<GoogleSignInAccount?> getGoogleAccount() async {
    log("Initiating Google Sign-In");
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        log("User cancelled the sign-in process");
        return null;
      }
      log("Google Sign-In successful: ${account.email}");
      return account;
    } catch (e) {
      log("Google Sign-In error: $e");
      return null;
    }
  }

  // Sign-In with Google
  static Future<Either> signInWithGoogle(
      {required String idToken, required bool rememberMe}) async {
    try {
      final response = await _dioClient.post(
        ConstApi.signInWithGoogleUrl,
        queryParameters: {
          "googleToken": idToken,
          "rememberMe": rememberMe,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(response.data.toString());
      }
    } on DioException catch (e) {
      return Left(e.response?.data.toString());
    }
  }

  static Future<Either> googleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      log("Google Sign-Out successful");
      return Right("Sign-Out successful");
    } catch (e) {
      log("Google Sign-Out error: $e");
      return Left("Sign-Out failed: $e");
    }
  }
}
