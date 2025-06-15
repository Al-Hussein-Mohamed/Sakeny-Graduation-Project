part of '../change_password_screen.dart';

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
      ConstImages.changePassword,
      width: 250.w,
    );
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return Text(
      lang.createNewPassword,
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);

    return Hero(
      tag: "Password-tag",
      child: PasswordTextField(
        label: lang.password,
        passwordController: forgetPasswordCubit.passwordController,
      ),
    );
  }
}

class _ConfirmPassword extends StatelessWidget {
  const _ConfirmPassword();

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);

    return PasswordTextField(
      label: lang.confirmPassword,
      passwordController: forgetPasswordCubit.confirmPasswordController,
    );
  }
}

class _ChangePasswordButton extends StatelessWidget {
  const _ChangePasswordButton();

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);

    return Hero(
      tag: "button",
      child: ElevatedButton(
        onPressed: forgetPasswordCubit.changePassword,
        child: Text(lang.change),
      ),
    );
  }
}
