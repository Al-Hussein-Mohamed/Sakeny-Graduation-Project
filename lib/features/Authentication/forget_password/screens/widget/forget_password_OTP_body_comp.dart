part of '../forget_password_OTP_screen.dart';

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return const TopBarLanguage();
  }
}

class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ConstImages.forgetPasswordOTP,
      width: 250.w,
    );
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Text(
            lang.forgetPasswordOTPTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            lang.forgetPasswordOTPBody,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OTP extends StatelessWidget {
  const _OTP();

  @override
  Widget build(BuildContext context) {
    return const OTPWidget();
  }
}

class _ResendOTPTimer extends StatelessWidget {
  const _ResendOTPTimer();

  @override
  Widget build(BuildContext context) {
    return const ResendOTPTimer();
  }
}

class _VerifyButton extends StatelessWidget {
  const _VerifyButton();

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);
    return Hero(
      tag: "button",
      child: ElevatedButton(
        onPressed: forgetPasswordCubit.verifyOTP,
        child: Text(lang.forgetPasswordOTPButton),
      ),
    );
  }
}
