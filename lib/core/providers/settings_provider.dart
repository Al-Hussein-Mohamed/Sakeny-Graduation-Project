import "dart:developer";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:internet_connection_checker_plus/internet_connection_checker_plus.dart";
import "package:sakeny/common/models/user_model.dart";
import "package:sakeny/core/routing/page_route_name.dart";
import "package:sakeny/core/services/navigation_service.dart";
import "package:sakeny/core/services/service_locator.dart";
import "package:shared_preferences/shared_preferences.dart";

class SettingsProvider extends ChangeNotifier {
  SettingsProvider();

  @override
  void dispose() {
    if (_internetSubscription != null) {
      _internetSubscription!.cancel();
    }
    super.dispose();
  }

  final _secureStorage = sl<FlutterSecureStorage>();
  final _prefs = sl<SharedPreferences>();
  final _navigator = sl<NavigationService>();

  dynamic _internetSubscription;

  Future<void> settingsSetup() async {
    await Future.wait([
      restoreSkipOnboarding(),
      restoreLanguage(),
      restoreTheme(),
      restoreToken(),
      // _initializeInternetConnection(),
    ]);
  }

  //----------------------> Variables <---------------------------
  String? lastProfileUserID;

  //----------------------> Internet Connection <------------------------------
  bool isConnected = false;
  bool isConnectionLostScreenViewed = false;

  // final internetConnectionStream = InternetConnection().onStatusChange;

  // Future _initializeInternetConnection() async {
  //   _internetSubscription = internetConnectionStream.listen(_connectionListener);
  // }

  void _connectionListener(InternetStatus status) {
    final bool newStatus = status == InternetStatus.connected;
    if (isConnected == newStatus) return;
    log("Connection Status: $status");
    isConnected = newStatus;
    if (isConnected) {
      exitConnectionLostScreen();
    } else {
      gotToConnectionLostScreen();
    }
  }

  void gotToConnectionLostScreen() {
    if (isConnectionLostScreenViewed) {
      log("already at connection lost screen");
      return;
    }
    log("Navigating to Internet Connection Lost Screen");
    isConnectionLostScreenViewed = true;
    _navigator.navigateTo(PageRouteNames.internetConnectionLost);
  }

  void exitConnectionLostScreen() {
    if (!isConnectionLostScreenViewed) {
      log("Connection Lost Screen not viewed, no action taken");
      return;
    }

    log("Exiting Internet Connection Lost Screen");
    isConnectionLostScreenViewed = false;
    _navigator.pop();
  }

  //----------------------> Tokens <------------------------------
  final String _accessTokenKey = "token";
  final String _refreshTokenKey = "refresh_token";
  final String _rememberMeKey = "remember_me";
  final String _userIdKey = "user_id";

  UserAuthState user = const GuestUser();
  bool rememberMe = false;
  String? userId;
  String? accessToken;
  String? refreshToken;

  void exitApp() {
    if (rememberMe) return;
    clearToken();
  }

  void setToken(
    String accessToken,
    String refreshToken,
    String? userId,
    bool? rememberMe,
  ) async {
    if (rememberMe != null) {
      this.rememberMe = rememberMe;
    }

    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    if (userId != null) {
      this.userId = userId;
    }

    user = AuthenticatedUser();

    await saveToken(accessToken, refreshToken, userId, rememberMe);
    notifyListeners();
  }

  Future clearToken() async {
    if (kDebugMode) {
      print('Clearing user tokens and session data');
    }

    rememberMe = false;
    accessToken = null;
    refreshToken = null;
    userId = null;
    user = const GuestUser();
    await deleteToken();
    notifyListeners();
  }

  Future saveToken(
      String accessToken, String refreshToken, String? userId, bool? rememberMe) async {
    if (rememberMe != null) {
      _prefs.setBool(_rememberMeKey, rememberMe);
    }

    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
      if (userId != null) _secureStorage.write(key: _userIdKey, value: userId),
    ]);
  }

  Future<void> restoreToken() async {
    rememberMe = _prefs.getBool(_rememberMeKey) ?? false;

    if (!rememberMe) {
      await clearToken();
      return;
    }

    try {
      accessToken = await _secureStorage.read(key: _accessTokenKey);
      refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      userId = await _secureStorage.read(key: _userIdKey);

      if (accessToken == null || refreshToken == null || userId == null) {
        await clearToken();
        return;
      }

      user = AuthenticatedUser();

      if (kDebugMode) {
        print("Tokens restored successfully");
        print("Access Token: $accessToken");
        print("Refresh Token: $refreshToken");
        print("User ID: $userId");
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to read from secure storage, likely due to app reinstall or data clear.");
        print("Error: $e");
      }
      await clearToken();
    } catch (e) {
      if (kDebugMode) {
        print("An unexpected error occurred during token restoration: $e");
      }
      await clearToken();
    }
  }

  Future deleteToken() async {
    Future.wait([
      _prefs.remove(_rememberMeKey),
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
      _secureStorage.delete(key: _userIdKey),
    ]);

    if (kDebugMode) {
      print('Tokens deleted from secure storage');
    }
  }

  //----------------------> Onboarding Manager <----------------------
  final String prefOnboarding = "onboarding";
  bool _skipOnboarding = false;

  void setSkipOnboarding() {
    _skipOnboarding = true;
    saveSkipOnboarding();
  }

  String getInitScreen() {
    if (accessToken != null) return PageRouteNames.home;
    return _skipOnboarding ? PageRouteNames.login : PageRouteNames.onboarding;
  }

  void saveSkipOnboarding() async {
    await _prefs.setBool(prefOnboarding, true);
  }

  Future<void> restoreSkipOnboarding() async {
    _skipOnboarding = _prefs.getBool(prefOnboarding) ?? false;
  }

  //----------------------> Localization <----------------------

  final String prefLanguage = "language";
  final List<String> languages = ["English", "العربية"];
  String currentLanguage = "en";

  get isEn => currentLanguage == "en";

  Map<String, String> languageMap = {
    "English": "en",
    "العربية": "ar",
  };

  void setLanguage(String? newLanguage) {
    if (newLanguage == null) return;
    newLanguage = languageMap[newLanguage] ?? "en";
    if (currentLanguage == newLanguage) return;
    currentLanguage = newLanguage;
    saveLanguage();
    notifyListeners();
  }

  void setLanguageByCode(String? newLang) {
    if (newLang == null) return;
    if (newLang == currentLanguage) return;
    currentLanguage = newLang;
    saveLanguage();
    notifyListeners();
  }

  void saveLanguage() async {
    await _prefs.setString(prefLanguage, currentLanguage);
  }

  Future<void> restoreLanguage() async {
    currentLanguage = _prefs.getString(prefLanguage) ?? "en";
  }

  //----------------------> Theming <----------------------

  final String prefTheme = "theme";
  bool isDarkMode = false;

  void toggleTheme(int mode) {
    if ((mode == 1) == isDarkMode) return;
    isDarkMode = mode == 0 ? false : true;
    saveTheme();
    notifyListeners();
  }

  void saveTheme() async {
    await _prefs.setBool(prefTheme, isDarkMode);
  }

  Future<void> restoreTheme() async {
    isDarkMode = _prefs.getBool(prefTheme) ?? false;
  }
}
