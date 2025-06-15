import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/custom_elevated_button.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/generated/l10n.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  final _settings = sl<SettingsProvider>();

  String _selectedLanguage = "en";

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _settings.currentLanguage;
  }

  void _onLanguageChanged(String? newLang) {
    if (newLang == null) return;
    setState(() => _selectedLanguage = newLang);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      // color: theme.colorScheme.onSurface,
      padding: const EdgeInsets.only(
        top: 10,
        bottom: ConstConfig.screenVerticalPadding,
        left: ConstConfig.screenHorizontalPadding,
        right: ConstConfig.screenHorizontalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Header(),
          const SizedBox(height: 10),
          _Languages(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: _onLanguageChanged,
          ),
          const SizedBox(height: 20),
          _ApplyButton(selectedLanguage: _selectedLanguage),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Column(
      children: [
        Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        const SizedBox(height: 12),
        Text(lang.language, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        const Divider(thickness: .3, color: Colors.grey),
      ],
    );
  }
}

class _Languages extends StatelessWidget {
  const _Languages({required this.selectedLanguage, this.onLanguageChanged});

  final String selectedLanguage;
  final void Function(String?)? onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = sl<SettingsProvider>();
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        for (final String lang in settings.languages)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: RadioListTile<String>(
              title: Text(
                lang,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              value: settings.languageMap[lang] ?? "language not found",
              groupValue: selectedLanguage,
              onChanged: onLanguageChanged,
              activeColor: CustomColorScheme.getColor(context, CustomColorScheme.text),
              fillColor: WidgetStateProperty.resolveWith(
                (states) => CustomColorScheme.getColor(context, CustomColorScheme.text),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: ConstConfig.borderRadius,
              ),
              visualDensity: const VisualDensity(horizontal: -4.0),
            ),
          ),
      ],
    );
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton({required this.selectedLanguage});

  final String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = sl<SettingsProvider>();
    final S lang = S.of(context);
    return CustomElevatedButton(
      isPrimary: true,
      onPressed: selectedLanguage != settings.currentLanguage
          ? () {
              Navigator.pop(context);
              settings.setLanguageByCode(selectedLanguage);
            }
          : null,
      child: Text(lang.apply),
    );
  }
}
