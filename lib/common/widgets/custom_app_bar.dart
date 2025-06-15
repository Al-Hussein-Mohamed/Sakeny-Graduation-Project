import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
    this.screenTitle,
    this.openDrawer,
    this.onBack, {
    super.key,
  });

  static final _drawerIcon = SvgPicture.asset(
    ConstImages.drawerIcon,
    width: ConstConfig.iconSize,
    height: ConstConfig.iconSize,
  );

  final String screenTitle;
  final VoidCallback openDrawer;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: onBack,
      ),
      title: Text(screenTitle),
      actions: [
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          onTap: openDrawer,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: _drawerIcon,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
