import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/features/drawer/models/drawer_tile_model.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.drawerTile,
    required this.onTap,
  });

  final DrawerTileModel drawerTile;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: CustomListTile(drawerTile: drawerTile, enabled: onTap != null),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.drawerTile,
    required this.enabled,
  });

  final bool enabled;
  final DrawerTileModel drawerTile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final originalColor = CustomColorScheme.getColor(context, CustomColorScheme.drawerTile);
    final color = enabled ? originalColor : originalColor.withValues(alpha: .5);

    return ListTile(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsetsDirectional.only(start: 8),
      visualDensity: const VisualDensity(vertical: -3),
      minVerticalPadding: 0,
      leading: SvgPicture.asset(
        drawerTile.icon,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        drawerTile.title,
        style: theme.textTheme.bodyMedium?.copyWith(color: color),
      ),
    );
  }
}
