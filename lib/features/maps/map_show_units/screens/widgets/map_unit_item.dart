import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/features/maps/map_show_units/controllers/map_show_units_config.dart';
import 'package:sakeny/features/maps/map_show_units/controllers/map_show_units_cubit.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/post/posts/screens/post_widget.dart';

class MapUnitItem extends StatelessWidget {
  const MapUnitItem({super.key, required this.post, required this.index});

  final int index;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    final ThemeData theme = Theme.of(context);

    void goToUnitScreen(BuildContext context) {
      Navigator.pushNamed(context, PageRouteNames.unit, arguments: post);
    }

    return Container(
      height: MapShowUnitsConfig.uintItemHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: MapShowUnitsConfig.unitItemVerticalMargin,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        border:
            Border.all(color: post.unit.isRented ? Colors.green : colors.unitBorder, width: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => goToUnitScreen(context),
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(flex: 4, child: _UnitImage(post: post, postIndex: index)),
                  const SizedBox(width: 10),
                  Expanded(flex: 5, child: _UnitDescription(post: post)),
                ],
              ),
            ),
          ),
          _LocationButton(post: post, index: index),
        ],
      ),
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({
    required this.post,
    required this.index,
  });

  final PostModel post;
  final int index;

  @override
  Widget build(BuildContext context) {
    final MapShowUnitsCubit mapShowUnitsCubit = MapShowUnitsCubit.of(context);
    final AppColors colors = AppColors.of(context);
    return PositionedDirectional(
      top: 5,
      end: 5,
      child: InkWell(
        onTap: () => mapShowUnitsCubit.locateUnitOnMap(post.unit.location, index),
        child: Icon(Icons.location_on, color: colors.text),
      ),
    );
  }
}

class _UnitImage extends StatelessWidget {
  const _UnitImage({required this.post, required this.postIndex});

  final int postIndex;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final MapShowUnitsCubit mapShowUnitsCubit = MapShowUnitsCubit.of(context);
    final SettingsProvider settings = sl<SettingsProvider>();

    return Stack(
      children: [
        _Image(imageUrl: post.unit.unitPicturesUrls[0]),
        FavoriteButton(
          index: postIndex,
          postId: post.postId,
          isFavorite: post.isFavorite,
          bottomOffset: 5,
          rightOffset: settings.isEn ? 5 : null,
          leftOffset: settings.isEn ? null : 5,
          addToFavorites: mapShowUnitsCubit.addPostToFavorites,
          removeFromFavorites: mapShowUnitsCubit.removePostFromFavorites,
        ),
      ],
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MapShowUnitsConfig.uintItemHeight - 16;
    return ClipRRect(
      borderRadius: const BorderRadiusDirectional.horizontal(start: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: imageHeight,
        width: double.infinity,
        key: ValueKey<String>(imageUrl),
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: imageHeight,
          color: ConstColors.primaryColor.withValues(alpha: 0.1),
        ),
        errorWidget: (context, url, error) => Container(
          color: ConstColors.primaryColor.withValues(alpha: 0.1),
          child: const Icon(
            Icons.error_outline,
            color: ConstColors.primaryColor,
          ),
        ),
        cacheKey: imageUrl,
        memCacheHeight: 1024,
        memCacheWidth: 1024,
      ),
    );
  }
}

class _UnitDescription extends StatelessWidget {
  const _UnitDescription({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double rate = ((post.unit.unitRate * 10).toInt() / 10).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(post.unit.unitType.getString(context)),
        // Text(unit.address, style: theme.textTheme.bodySmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PostUnitInfoWidget(unit: post.unit),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 20),
                Text(rate.toString(), style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
        PostUnitPriceInfo(context: context, unit: post.unit),
      ],
    );
  }
}
