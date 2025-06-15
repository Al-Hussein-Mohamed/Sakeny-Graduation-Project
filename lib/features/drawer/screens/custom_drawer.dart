import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:sakeny/common/models/user_model.dart";
import "package:sakeny/core/constants/const_images.dart";
import "package:sakeny/core/theme/widget_themes/custom_color_scheme.dart";
import "package:sakeny/features/drawer/controllers/on_tile_tap.dart";
import 'package:sakeny/features/drawer/models/drawer_tile_model.dart';
import 'package:sakeny/features/drawer/screens/widgets/custom_drawer_header.dart';
import "package:sakeny/features/drawer/screens/widgets/custom_theme_mode_button.dart";
import 'package:sakeny/features/drawer/screens/widgets/drawer_list_tile.dart';
import "package:sakeny/features/home/controllers/home_cubit.dart";

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width * .82;
    final drawerTiles = getDrawerTiles(context);

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(20),
          bottomStart: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      ConstImages.drawerClose,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        CustomColorScheme.getColor(context, CustomColorScheme.drawerTile),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const CustomThemeModeButton(),
                ],
              ),
            ),
            const CustomDrawerHeader(),
            for (final e in (homeCubit.user is GuestUser
                ? drawerTiles.sublist(0, drawerTiles.length - 1)
                : drawerTiles))
              DrawerListTile(
                key: ValueKey<String>(e.title),
                drawerTile: e,
                onTap: homeCubit.user is GuestUser && guestDisabled.contains(e.id)
                    ? null
                    : onTileTap(context, e, ModalRoute.of(context)?.settings.name ?? ""),
              ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
