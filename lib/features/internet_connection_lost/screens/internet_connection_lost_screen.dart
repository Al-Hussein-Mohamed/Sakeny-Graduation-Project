import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/custom_circle_progress_indicator.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/generated/l10n.dart';

class InternetConnectionLostScreen extends StatefulWidget {
  const InternetConnectionLostScreen({super.key});

  @override
  State<InternetConnectionLostScreen> createState() => _InternetConnectionLostScreenState();
}

class _InternetConnectionLostScreenState extends State<InternetConnectionLostScreen> {
  final _settings = sl<SettingsProvider>();
  bool _isLoading = false;

  Future<bool> _checkInternetConnection() async {
    try {
      final response = await Dio().get(
        'https://www.google.com/generate_204',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  void _checkInternetOnTap() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final res = await _checkInternetConnection();
    if (res) {
      _settings.exitConnectionLostScreen();
    } else {
      ToastificationService.showGlobalSomethingWentWrongToast();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final colors = AppColors.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(lang.internetConnectionLostTitle),
        ),
        body: Center(
          child: Padding(
            padding: ConstConfig.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.signal_wifi_off, size: 100, color: colors.text),
                const SizedBox(height: 20),
                Text(
                  lang.internetConnectionLostMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkInternetOnTap,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: _isLoading
                      ? const CustomCircleProgressIndicator(color: Colors.white)
                      : Text(lang.internetCheckAgain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
