import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/generated/l10n.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key, required this.date});

  final DateTime date;

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final S lang = S.of(context);

    if (_isSameDay(date, now)) {
      return lang.today; // Use localized "Today"
    } else if (_isSameDay(date, DateTime(now.year, now.month, now.day - 1))) {
      return lang.yesterday; // Use localized "Yesterday"
    } else {
      // Use localized date format based on current locale
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat('EEEE, MMMM d', locale).format(date);
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ConstColors.primaryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.textFieldBorder.withValues(alpha: .3)),
          ),
          child: Text(
            _formatDate(context, date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: .8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
