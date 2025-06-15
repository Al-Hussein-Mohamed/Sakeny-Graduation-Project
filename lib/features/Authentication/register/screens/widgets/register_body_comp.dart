part of '../register_screen.dart';

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();

    return TopBarLanguage(
      function: () => registerCubit.goToLogin(context),
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    return ProfilePicture(
      getProfilePic: registerCubit.getProfilePic,
      selectProfilePic: registerCubit.selectProfilePic,
      clearProfilePic: registerCubit.clearProfilePic,
    );
  }
}

class _Text extends StatelessWidget {
  const _Text();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    return Text(
      lang.registerTitle,
      style: theme.textTheme.titleMedium,
    );
  }
}

class _FirstName extends StatelessWidget {
  const _FirstName();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return NameTextField(
      label: lang.firstName,
      nameController: registerCubit.firstNameController,
    );
  }
}

class _SecondName extends StatelessWidget {
  const _SecondName();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return NameTextField(
      label: lang.secondName,
      nameController: registerCubit.secondNameController,
    );
  }
}

class _PhoneNumber extends StatelessWidget {
  const _PhoneNumber();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return PhoneTextField(
      label: lang.phoneNumber,
      phoneController: registerCubit.phoneNumberController,
    );
  }
}

class _Location extends StatelessWidget {
  const _Location();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    return Hero(
      tag: ConstConfig.selectLocationHeroTag,
      child: SelectLocation(
        locationController: registerCubit.locationController,
        onTap: () => registerCubit.goToMapSelectLocation(context),
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();

    return EmailTextField(
      emailController: registerCubit.emailController,
    );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return PasswordTextField(
      label: lang.password,
      passwordController: registerCubit.passwordController,
    );
  }
}

class _ConfirmPassword extends StatelessWidget {
  const _ConfirmPassword();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return PasswordTextField(
      label: lang.confirmPassword,
      passwordController: registerCubit.confirmPasswordController,
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return Hero(
      tag: "button",
      child: ElevatedButton(
        onPressed: registerCubit.register,
        child: Text(lang.create),
      ),
    );
  }
}
