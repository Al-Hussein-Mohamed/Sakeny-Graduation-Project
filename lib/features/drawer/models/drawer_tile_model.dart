import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/constants/const_text.dart';
import 'package:sakeny/generated/l10n.dart';

class DrawerTileModel {
  const DrawerTileModel({
    required this.id,
    required this.title,
    required this.icon,
  });

  final String id;
  final String title;
  final String icon;
}

List<DrawerTileModel> getDrawerTiles(BuildContext context) {
  final S lang = S.of(context);
  return [
    DrawerTileModel(
      id: ConstText.drawerMyProfile,
      title: lang.drawerMyProfile,
      icon: ConstImages.drawerMyProfile,
    ),
    DrawerTileModel(
      id: ConstText.drawerHome,
      title: lang.drawerHome,
      icon: ConstImages.drawerHome,
    ),
    DrawerTileModel(
      id: ConstText.drawerChat,
      title: lang.drawerChat,
      icon: ConstImages.drawerChat,
    ),
    DrawerTileModel(
      id: ConstText.drawerFavorites,
      title: lang.drawerFavorites,
      icon: ConstImages.drawerFavorites,
    ),
    DrawerTileModel(
      id: ConstText.drawerNotification,
      title: lang.drawerNotification,
      icon: ConstImages.drawerNotification,
    ),
    DrawerTileModel(
      id: ConstText.drawerFilters,
      title: lang.drawerFilters,
      icon: ConstImages.drawerFilter,
    ),
    DrawerTileModel(
      id: ConstText.drawerAddEstate,
      title: lang.drawerAddEstate,
      icon: ConstImages.drawerAddEstate,
    ),
    DrawerTileModel(
      id: ConstText.drawerLanguage,
      title: lang.drawerLanguage,
      icon: ConstImages.drawerLanguage,
    ),
    DrawerTileModel(
      id: ConstText.drawerLogout,
      title: lang.drawerLogout,
      icon: ConstImages.drawerLogout,
    ),
  ];
}
