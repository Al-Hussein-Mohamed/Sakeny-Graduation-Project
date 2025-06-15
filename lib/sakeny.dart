import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/common/widgets/set_up/animated_directional_wrapper.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/observers/keyboard_hiding_observer.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_router.dart';
import 'package:sakeny/core/services/navigation_service.dart';
import 'package:sakeny/core/services/overlays/loading_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/theme.dart';
import 'package:sakeny/core/utils/helpers/assets_cache_manager.dart';
import 'package:sakeny/generated/l10n.dart';

class Sakeny extends StatefulWidget {
  const Sakeny({super.key});

  @override
  State<Sakeny> createState() => _SakenyState();
}

class _SakenyState extends State<Sakeny> with WidgetsBindingObserver {
  final _navigationService = sl<NavigationService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // debugRepaintRainbowEnabled = true;
    // debugPaintLayerBordersEnabled = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AssetCacheManager().preloadAssets(
        images: AppAssets.images,
        svgs: AppAssets.svgs,
      );
    } else if (state == AppLifecycleState.detached) {
      sl<SettingsProvider>().exitApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    configEasyLoading(settings.isDarkMode);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AnimatedDirectionalWrapper(
      child: MaterialApp(
        title: 'Sakeny',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigationService.navigatorKey,
        scaffoldMessengerKey: _navigationService.scaffoldMessengerKey,
        locale: Locale(settings.currentLanguage),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: settings.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        initialRoute: settings.getInitScreen(),
        onGenerateRoute: PageRouter.onGenerateRoute,
        navigatorObservers: [KeyboardHidingObserver()],
        builder: EasyLoading.init(),
      ),
    );
  }
}
