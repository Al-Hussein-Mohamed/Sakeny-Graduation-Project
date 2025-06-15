import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/generated/l10n.dart';

class TopBarLanguage extends StatelessWidget {
  const TopBarLanguage({
    super.key,
    this.function,
    this.icon = Icons.arrow_back_ios_new,
  });

  final void Function()? function;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "languageTobBar",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: function ?? () => Navigator.pop(context),
            icon: Icon(
              icon,
              size: ConstConfig.iconSize,
              color: getColor(context, Colors.black, Colors.white),
            ),
          ),
          const _LanguageDropdownMenu(),
        ],
      ),
    );
  }
}

class _LanguageDropdownMenu extends StatefulWidget {
  const _LanguageDropdownMenu();

  @override
  State<_LanguageDropdownMenu> createState() => _LanguageDropdownMenuState();
}

class _LanguageDropdownMenuState extends State<_LanguageDropdownMenu> {
  final SettingsProvider _settings = sl<SettingsProvider>();
  final GlobalKey _buttonKey = GlobalKey();
  final int _animatedDuration = 300 - 120;
  double _buttonWidth = 0;
  final double _buttonHeight = 44;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _buttonWidth = _settings.isEn ? 160 : 135;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buttonWidth = _settings.isEn ? 160 : 135;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return PopupMenuButton<String>(
      key: _buttonKey,
      position: PopupMenuPosition.under,
      constraints: BoxConstraints(minWidth: _buttonWidth, maxWidth: _buttonWidth),
      elevation: ConstConfig.smallElevation,
      color: theme.colorScheme.onSurface,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      onOpened: () => setState(() => isExpanded = true),
      onCanceled: () async {
        Future.delayed(Duration(milliseconds: _animatedDuration)).then((_) {
          if (isExpanded) {
            setState(() => isExpanded = false);
          }
        });
      },
      onSelected: (lang) async {
        sl.get<SettingsProvider>().setLanguage(lang);
        await Future.delayed(Duration(milliseconds: _animatedDuration));
        if (isExpanded) {
          setState(() => isExpanded = false);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'English',
          padding: const EdgeInsets.only(top: 4, bottom: 6),
          child: Center(
            child: Text(
              'English',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 18.spMin,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: 'العربية',
          padding: const EdgeInsets.only(bottom: 4, top: 6),
          child: Center(
            child: Text(
              "العربية",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 18.spMin,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
      child: Material(
        elevation: ConstConfig.smallElevation,
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(10),
          bottom: isExpanded ? Radius.zero : const Radius.circular(10),
        ),
        child: AnimatedContainer(
          duration:
              isExpanded ? const Duration(milliseconds: 10) : const Duration(milliseconds: 200),
          height: _buttonHeight,
          width: _buttonWidth,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(10),
              bottom: isExpanded ? Radius.zero : const Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 8),
              Center(
                child: FittedBox(
                  child: Text(
                    lang.language,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontSize: 18.spMin, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
  }
}
