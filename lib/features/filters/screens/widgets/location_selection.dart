import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/filters/controllers/filter_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class LocationSelection extends StatelessWidget {
  const LocationSelection({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final FiltersCubit filtersCubit = context.read<FiltersCubit>();
    final S lang = S.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: [
              Text(
                filtersCubit.location == null ? lang.select : filtersCubit.addressController.text,
                style: Theme.of(context).brightness == Brightness.light
                    ? CustomTextTheme.lightTextTheme.bodySmall
                    : CustomTextTheme.darkTextTheme.bodySmall,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color:
                    Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
