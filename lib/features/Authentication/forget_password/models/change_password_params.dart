class ChangePasswordParams {

  ChangePasswordParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  final String email;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson(){
    return {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    };
  }
}
