import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_overlay_controls_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_search_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_select_location_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/maps/map_select_location/screens/widget/map_search_bar.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

part 'widget/address_bar.dart';
part 'widget/get_current_location_button.dart';
part 'widget/overlay_controls.dart';

class MapSelectLocationScreen extends StatelessWidget {
  const MapSelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return CustomScaffold(
      screenTitle: lang.selectLocation,
      onBack: () => Navigator.pop(context),
      body: const _MapSelectLocationContent(),
    );
  }
}

class _MapSelectLocationContent extends StatefulWidget {
  const _MapSelectLocationContent();

  @override
  State<_MapSelectLocationContent> createState() => _MapSelectLocationContentState();
}

class _MapSelectLocationContentState extends State<_MapSelectLocationContent> {
  @override
  Widget build(BuildContext context) {
    final MapSelectLocationCubit mapCubit = context.read<MapSelectLocationCubit>();
    return BlocConsumer<MapSelectLocationCubit, MapSelectLocationState>(
      listener: (context, state) {
        if (state is MapSelectLocationError) {
          ToastificationService.showErrorToast(context, state.message);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            if (mapCubit.showMap) const _MapView(),
            const _OverlayControls(),
            const MapSearchBar(),
            if (!state.isMapReady) const _LoadingOverlay(),
          ],
        );
      },
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return Container(
      color: Colors.grey.shade200.withValues(alpha: 0.88),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              lang.mapIsLoading,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    final MapSelectLocationCubit mapCubit = context.read<MapSelectLocationCubit>();
    final MapOverlayControlsCubit overlayControlsCubit = context.read<MapOverlayControlsCubit>();
    final MapSearchCubit searchCubit = context.read<MapSearchCubit>();

    return BlocBuilder<MapSelectLocationCubit, MapSelectLocationState>(
      builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: mapCubit.initialPosition,
          padding: const EdgeInsets.only(bottom: 85, right: 16, top: 70),
          zoomControlsEnabled: false,
          myLocationEnabled: state.permissionGranted,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            context.read<MapSelectLocationCubit>().initializeMap(controller);
          },
          onTap: (LatLng position) {
            searchCubit.unFocusSearch();
            overlayControlsCubit.getPlaceTitle(position);
            mapCubit.setSelectedLocation(position);
          },
          markers: state.selectedLocation != null
              ? {
                  Marker(
                    markerId: const MarkerId("selected_location"),
                    position: state.selectedLocation!,
                  ),
                }
              : {},
        );
      },
    );
  }
}
