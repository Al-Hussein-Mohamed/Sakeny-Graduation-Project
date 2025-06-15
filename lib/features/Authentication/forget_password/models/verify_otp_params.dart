class VerifyOtpParams {

  // final int otp;

  VerifyOtpParams({
    required this.email,
    required this.otpList,
  }) {
    int sum = 0;
    for (final d in otpList) {
      sum *= 10;
      sum += d;
    }
    otp = sum;
  }
  final String email;
  final List<int> otpList;
  late int otp;

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
    };
  }
}
