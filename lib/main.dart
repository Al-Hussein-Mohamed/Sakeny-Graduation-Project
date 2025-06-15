import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/common/widgets/set_up/preview.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/observers/bloc_observer.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/notificaion_services/local_notification_services.dart';
import 'package:sakeny/core/services/notificaion_services/push_notifications_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/utils/helpers/assets_cache_manager.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/firebase_options.dart';
import 'package:sakeny/sakeny.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await serviceLocatorSetup();
  await ScreenUtil.ensureScreenSize();
  final isReal = await isPhysicalDevice();
  await sl<SettingsProvider>().settingsSetup();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationsService.init();
  await LocalNotificationServices.init();

  await AssetCacheManager().preloadAssets(
    images: AppAssets.images,
    svgs: AppAssets.svgs,
  );

  runApp(
    Preview(
      devicePreview: false,
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ChangeNotifierProvider(
            create: (_) => sl<SettingsProvider>(),
            child: const Sakeny(),
          );
        },
      ),
    ),
  );
}
