part of '../edit_profile_screen.dart';

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        // print(editProfileCubit.editedUser.profilePictureURL);
        return Hero(
          tag: ConstConfig.profilePicTag,
          child: ProfilePicture(
            profilePicUrl: editProfileCubit.editedUser.profilePictureURL,
            getProfilePic: editProfileCubit.getProfilePic,
            selectProfilePic: editProfileCubit.selectProfilePic,
            clearProfilePic: editProfileCubit.clearProfilePic,
          ),
        );
      },
    );
  }
}

class _FirstName extends StatelessWidget {
  const _FirstName();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final S lang = S.of(context);
    return NameTextField(
      label: lang.firstName,
      nameController: editProfileCubit.firstNameController,
      focusNode: editProfileCubit.firstNameFocusNode,
      onChanged: (_) => editProfileCubit.checkChanges(),
    );
  }
}

class _SecondName extends StatelessWidget {
  const _SecondName();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final S lang = S.of(context);
    return NameTextField(
      label: lang.secondName,
      nameController: editProfileCubit.secondNameController,
      focusNode: editProfileCubit.secondNameFocusNode,
      onChanged: (_) => editProfileCubit.checkChanges(),
    );
  }
}

class _PhoneNumber extends StatelessWidget {
  const _PhoneNumber();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final S lang = S.of(context);
    return PhoneTextField(
      label: lang.phoneNumber,
      phoneController: editProfileCubit.phoneNumberController,
      focusNode: editProfileCubit.phoneNumberFocusNode,
      onChanged: (_) => editProfileCubit.checkChanges(),
    );
  }
}

class _Location extends StatelessWidget {
  const _Location();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();

    return SelectLocation(
      locationController: editProfileCubit.locationController,
      onTap: () => editProfileCubit.goToMapSelectLocation(context),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();

    return EmailTextField(
      enabled: false,
      emailController: editProfileCubit.emailController,
    );
  }
}

class _ChangePassword extends StatelessWidget {
  const _ChangePassword();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    return Padding(
      padding: ConstConfig.textFieldPadding,
      child: TextField(
        readOnly: true,
        onTap: () => _changePasswordOnTap(context),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          label: Text(
            lang.changePassword,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 18.spMin,
              fontWeight: FontWeight.w500,
            ),
          ),
          prefixIcon: ImageIcon(
            const AssetImage(ConstImages.passwordIcon),
            color: CustomColorScheme.getColor(context, CustomColorScheme.text),
          ),
          suffixIcon: Icon(
            Icons.arrow_forward_ios_outlined,
            color: CustomColorScheme.getColor(context, CustomColorScheme.text),
          ),
        ),
      ),
    );
  }

  void _changePasswordOnTap(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, PageRouteNames.login, (route) => false);
    sl<NavigationService>().navigateTo(PageRouteNames.forgotPassword);
    sl<SettingsProvider>().clearToken();
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final S lang = S.of(context);

    return BlocSelector<EditProfileCubit, EditProfileState, bool>(
      selector: (state) => state.isChanged,
      builder: (context, isChanged) {
        return CustomElevatedButton(
          isPrimary: false,
          onPressed: isChanged ? editProfileCubit.save : null,
          child: Text(lang.save),
        );
      },
    );
  }
}
