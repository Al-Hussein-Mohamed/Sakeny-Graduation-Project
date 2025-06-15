import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sakeny/core/network/dio_client.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> serviceLocatorSetup() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<DioClient>(DioClient.new)
    ..registerLazySingleton<SettingsProvider>(SettingsProvider.new)
    ..registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new)
    ..registerLazySingleton<NavigationService>(NavigationService.new)
    ..registerSingleton<SharedPreferences>(sharedPrefs);
}
