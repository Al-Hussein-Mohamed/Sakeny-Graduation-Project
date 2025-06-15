part of '../forget_password_screen.dart';

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
      ConstImages.forgetPassword,
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
            lang.forgetPasswordTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            lang.forgetPasswordBody,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>()
      ..fetchEmail(context);
    return Hero(
      tag: "Email-tag",
      child: EmailTextField(
        emailFocusNode: forgetPasswordCubit.emailFocusNode,
        emailController: forgetPasswordCubit.emailController,
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton();

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);
    return Hero(
      tag: "button",
      child: ElevatedButton(
        onPressed: forgetPasswordCubit.sendEmail,
        child: Text(lang.forgetPasswordButton),
      ),
    );
  }
}
