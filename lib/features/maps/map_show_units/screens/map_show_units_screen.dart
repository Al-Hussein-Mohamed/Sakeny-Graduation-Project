import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/features/maps/map_show_units/controllers/map_show_units_config.dart';
import 'package:sakeny/features/maps/map_show_units/controllers/map_show_units_cubit.dart';
import 'package:sakeny/features/maps/map_show_units/screens/widgets/map_unit_item.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/generated/l10n.dart';

part 'widgets/draggable_units_sheet.dart';

class MapShowUnitsScreen extends StatelessWidget {
  const MapShowUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MapShowUnitsCubit mapShowUnitsCubit = MapShowUnitsCubit.of(context);

    return CustomScaffold(
      scaffoldKey: mapShowUnitsCubit.scaffoldKey,
      screenTitle: "",
      openDrawer: () => mapShowUnitsCubit.scaffoldKey.currentState?.openEndDrawer(),
      onBack: () => Navigator.pop(context),
      body: const _MapShowUnitsBody(),
    );
  }
}

class _MapShowUnitsBody extends StatelessWidget {
  const _MapShowUnitsBody();

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    return BlocBuilder<MapShowUnitsCubit, MapShowUnitsState>(
      builder: (context, state) {
        switch (state) {
          case MapShowUnitsLoading():
            return Center(child: CircularProgressIndicator(color: colors.text));
          case MapShowUnitsLoaded():
            if (state.posts.isEmpty) {
              return const _NoResultFound();
            }

            return _MapShowUnitsLoaded(
              initialPosition: state.posts[0].unit.location,
              markers: state.markers,
              posts: state.posts,
            );

          case MapShowUnitsError():
            return Center(child: Text((state).error, style: const TextStyle(color: Colors.red)));
        }
      },
    );
  }
}

class _MapShowUnitsLoaded extends StatelessWidget {
  const _MapShowUnitsLoaded({
    required this.initialPosition,
    required this.markers,
    required this.posts,
  });

  final LatLng initialPosition;
  final Set<Marker> markers;
  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    final MapShowUnitsCubit mapShowUnitsCubit = MapShowUnitsCubit.of(context);

    return Stack(
      children: [
        _GoogleMaps(
          initialPosition: initialPosition,
          mapShowUnitsCubit: mapShowUnitsCubit,
          markers: markers,
        ),
        _DraggableUnitsSheet(posts: posts),
      ],
    );
  }
}

class _GoogleMaps extends StatelessWidget {
  const _GoogleMaps({
    required this.initialPosition,
    required this.mapShowUnitsCubit,
    required this.markers,
  });

  final LatLng initialPosition;
  final MapShowUnitsCubit mapShowUnitsCubit;
  final Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 16,
      ),
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: mapShowUnitsCubit.mapController.complete,
      markers: markers,
      onTap: (position) {
        mapShowUnitsCubit.collapseSheet();
      },
      onCameraMove: (position) {
        mapShowUnitsCubit.collapseSheet();
      },
      padding: EdgeInsets.only(
        bottom: MapShowUnitsConfig.minChildSize * MediaQuery.of(context).size.height,
      ),
    );
  }
}

class _NoResultFound extends StatelessWidget {
  const _NoResultFound();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Center(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  theme.brightness == Brightness.light
                      ? ConstImages.emptySearchLight
                      : ConstImages.emptySearchDark,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(lang.noResultsFound, style: theme.textTheme.titleMedium),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Padding(
            padding: ConstConfig.screenPadding,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.searchAgain),
            ),
          ),
        ],
      ),
    );
  }
}
