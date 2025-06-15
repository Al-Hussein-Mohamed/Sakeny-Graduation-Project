import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/utils/helpers/assets_cache_manager.dart';

class AppStatusObserver extends StatefulWidget {
  const AppStatusObserver({super.key, required this.child});

  final Widget child;

  @override
  State<AppStatusObserver> createState() => _AppStatusObserverState();
}

class _AppStatusObserverState extends State<AppStatusObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      // sl<SettingsProvider>().exitApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
