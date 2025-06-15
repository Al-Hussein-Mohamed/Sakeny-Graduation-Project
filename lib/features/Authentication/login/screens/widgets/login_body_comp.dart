part of '../login_screen.dart';

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();

    return RepaintBoundary(
      child: TopBarLanguage(
        function: () => loginCubit.goToOnboarding(context),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S lang = S.of(context);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        children: [
          const Hero(
            tag: ConstConfig.logoTag,
            child: AppLogo(logoSize: 90),
          ),
          const SizedBox(height: 8),
          Text(lang.loginTitle, style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();

    return Hero(
      tag: "Email-tag",
      child: EmailTextField(
        padding: ConstConfig.textFieldPadding,
        emailController: loginCubit.emailController,
        emailFocusNode: loginCubit.emailFocusNode,
      ),
    );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final S lang = S.of(context);

    return Hero(
      tag: "Password-tag",
      child: PasswordTextField(
        checkValidator: false,
        padding: ConstConfig.textFieldPadding,
        label: lang.password,
        passwordController: loginCubit.passwordController,
        passwordFocusNode: loginCubit.passwordFocusNode,
      ),
    );
  }
}

class _RememberMeAndForgetPassword extends StatelessWidget {
  const _RememberMeAndForgetPassword();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _RememberMe(),
          RichText(
            text: TextSpan(
              text: lang.forgetPassword,
              style: theme.textTheme.bodySmall?.copyWith(color: ConstColors.linkColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () => loginCubit.goToForgetPassword(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _RememberMe extends StatefulWidget {
  const _RememberMe();

  @override
  State<_RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<_RememberMe> {
  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final borderColor = getColor(context, ConstColors.primaryColor, ConstColors.darkPrimary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: loginCubit.rememberMe,
          onChanged: (value) => setState(() => loginCubit.setRememberMe(value!)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return borderColor;
            }
            return Colors.transparent;
          }),
          side: BorderSide(color: borderColor, width: 2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        RichText(
          text: TextSpan(
            text: lang.rememberMe,
            style: theme.textTheme.bodySmall,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  loginCubit.setRememberMe(!loginCubit.rememberMe);
                });
              },
          ),
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final S lang = S.of(context);

    return Hero(
      tag: ConstConfig.authButtonTag,
      child: ElevatedButton(
        onPressed: loginCubit.signIn,
        child: Text(lang.signIn),
      ),
    );
  }
}

class _SignInCards extends StatelessWidget {
  const _SignInCards();

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    return Column(
      children: [
        Text(lang.or, style: theme.textTheme.bodySmall),
        const SizedBox(
          height: 12,
        ),
        // Sign in cards
        // Row(
        //   children: signInCards
        //       .map((card) => SignInCardWidget(signInCardModel: card))
        //       .toList(),
        // ),
        Row(
          children: [
            SignInCardWidget(
              signInCardModel: signInCards[0].copyWith(onTap: loginCubit.signInWithGoogle),
            ),
          ],
        )
      ],
    );
  }
}

class _Register extends StatelessWidget {
  const _Register();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return RichText(
      text: TextSpan(
        text: lang.dontHaveAccount,
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: lang.createAccount,
            style: theme.textTheme.bodySmall?.copyWith(color: ConstColors.linkColor),
            recognizer: TapGestureRecognizer()..onTap = () => loginCubit.goToRegister(context),
          ),
        ],
      ),
    );
  }
}

class _GuestLogin extends StatelessWidget {
  const _GuestLogin();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return GestureDetector(
      onTap: () => loginCubit.goToHome(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            lang.continueAsGuest,
            style: theme.textTheme.titleSmall?.copyWith(
              color: ConstColors.linkColor,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.arrow_forward_sharp,
            size: 18.spMin,
            color: ConstColors.linkColor,
          ),
        ],
      ),
    );
  }
}

class _AppVersion extends StatefulWidget {
  const _AppVersion();

  @override
  State<_AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<_AppVersion> {
  final _updater = ShorebirdUpdater();
  String _versionInfo = '';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    try {
      // Get the current patch information
      final currentPatch = await _updater.readCurrentPatch();
      // Get the app version
      if (mounted) {
        setState(() {
          final patchText = currentPatch != null ? currentPatch.number.toString() : 'none';
          _versionInfo = 'v: $patchText';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _versionInfo = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _versionInfo,
      style: TextStyle(
        fontSize: 9,
        color: Colors.grey.shade600,
      ),
    );
  }
}
