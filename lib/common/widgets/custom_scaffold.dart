import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/drawer/screens/custom_drawer.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.scaffoldKey,
    this.screenTitle,
    this.titleWidget,
    this.openDrawer,
    this.onBack,
    this.floatingActionButton,
  });

  static final _drawerIcon = SvgPicture.asset(
    ConstImages.drawerIcon,
    width: ConstConfig.iconSize,
    height: ConstConfig.iconSize,
  );

  final String? screenTitle;
  final VoidCallback? openDrawer;
  final VoidCallback? onBack;
  final Key? scaffoldKey;
  final Widget? titleWidget;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = sl<SettingsProvider>();
    final ThemeData theme = Theme.of(context);
    final AppBar appBar = screenTitle == null && titleWidget == null
        ? AppBar(
            toolbarHeight: 0,
            scrolledUnderElevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            // automaticallyImplyLeading: false,
            // forceMaterialTransparency: true,
          )
        : AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: onBack,
            ),
            title: titleWidget ?? Text(screenTitle!),
            actions: [
              openDrawer != null
                  ? Hero(
                      tag: ConstConfig.drawerIconTag,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        onTap: openDrawer,
                        child: Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: _drawerIcon,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: settings.isDarkMode
          ? _DarkScaffold(
              scaffoldKey: scaffoldKey,
              body: body,
              appBar: appBar,
              screenTitle: screenTitle,
              onBack: onBack,
              openDrawer: openDrawer,
              floatingActionButton: floatingActionButton,
            )
          : _LightScaffold(
              scaffoldKey: scaffoldKey,
              body: body,
              appBar: appBar,
              screenTitle: screenTitle,
              onBack: onBack,
              openDrawer: openDrawer,
              floatingActionButton: floatingActionButton,
            ),
    );
  }
}

class _LightScaffold extends StatelessWidget {
  const _LightScaffold({
    required this.body,
    required this.appBar,
    this.scaffoldKey,
    this.screenTitle,
    this.openDrawer,
    this.onBack,
    this.floatingActionButton,
  });

  final String? screenTitle;
  final VoidCallback? openDrawer;
  final VoidCallback? onBack;
  final Key? scaffoldKey;
  final Widget body;
  final AppBar appBar;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const CustomDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: body,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

class _DarkScaffold extends StatelessWidget {
  const _DarkScaffold({
    required this.body,
    required this.appBar,
    this.scaffoldKey,
    this.screenTitle,
    this.openDrawer,
    this.onBack,
    this.floatingActionButton,
  });

  final String? screenTitle;
  final VoidCallback? openDrawer;
  final VoidCallback? onBack;
  final Key? scaffoldKey;
  final Widget body;
  final AppBar appBar;
  final FloatingActionButton? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ConstImages.backgroundDark),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        endDrawer: const CustomDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: body,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
