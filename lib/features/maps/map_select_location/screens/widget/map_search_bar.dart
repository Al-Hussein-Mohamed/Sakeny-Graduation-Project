import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_overlay_controls_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_search_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/controllers/map_select_location_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/models/place_search_result_model.dart';
import 'package:sakeny/generated/l10n.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({super.key});

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 16,
      left: 0,
      right: 0,
      child: Column(
        children: [
          _SearchBar(),
          SizedBox(height: 6),
          _SearchResults(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _showClearButton = false;

  @override
  Widget build(BuildContext context) {
    final MapSearchCubit mapSearchCubit = context.read<MapSearchCubit>();
    final S lang = S.of(context);

    return Hero(
      tag: ConstConfig.selectLocationHeroTag,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          elevation: ConstConfig.elevation,
          shape: RoundedRectangleBorder(borderRadius: ConstConfig.borderRadius),
          child: TextField(
            controller: mapSearchCubit.searchController,
            focusNode: mapSearchCubit.searchFocusNode,
            // enabled: mapSearchCubit.isMapReady,
            decoration: _buildInputDecoration(lang, mapSearchCubit),
            onChanged: (value) {
              if (_showClearButton != value.isNotEmpty) {
                setState(() => _showClearButton = !_showClearButton);
              }
              mapSearchCubit.autoComplete(value);
            },
            style: const TextStyle(color: ConstColors.mapText),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(S lang, MapSearchCubit mapSearchCubit) {
    final ThemeData theme = Theme.of(context);

    return InputDecoration(
      hintText: lang.searchForLocation,
      hintStyle: theme.textTheme.bodySmall?.copyWith(color: ConstColors.mapText),
      prefixIcon: const Icon(Icons.search, color: ConstColors.mapText),
      suffixIcon: _showClearButton
          ? IconButton(
              icon: const Icon(Icons.clear, color: ConstColors.mapText),
              onPressed: () {
                setState(() => _showClearButton = false);
                mapSearchCubit.clearSearch();
              },
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      filled: true,
      fillColor: Colors.white,
      border:
          OutlineInputBorder(borderSide: BorderSide.none, borderRadius: ConstConfig.borderRadius),
      disabledBorder:
          OutlineInputBorder(borderSide: BorderSide.none, borderRadius: ConstConfig.borderRadius),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide.none, borderRadius: ConstConfig.borderRadius),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide.none, borderRadius: ConstConfig.borderRadius),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapSearchCubit, MapSearchState>(
      builder: (context, state) {
        switch (state) {
          case MapSearchInitial():
            return const SizedBox.shrink();
          case MapSearchLoaded():
            return _SearchResultLoaded(results: state.searchResults);
          case MapSearchError():
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _SearchResultLoaded extends StatelessWidget {
  const _SearchResultLoaded({required this.results});

  final List<PlaceSearchResult> results;

  @override
  Widget build(BuildContext context) {
    final MapSearchCubit mapSearchCubit = context.read<MapSearchCubit>();
    final bool showSearchResults = mapSearchCubit.searchFocusNode.hasFocus;

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      firstChild: _buildResults(),
      secondChild: const SizedBox.shrink(),
      crossFadeState: showSearchResults ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  Widget _buildResults() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        elevation: ConstConfig.elevation,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: ConstConfig.borderRadius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) => _SearchResultTile(result: results[index]),
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.result,
  });

  final PlaceSearchResult result;

  @override
  Widget build(BuildContext context) {
    final MapOverlayControlsCubit mapOverlayControlsCubit = context.read<MapOverlayControlsCubit>();
    final MapSelectLocationCubit mapCubit = context.read<MapSelectLocationCubit>();
    final MapSearchCubit mapSearchCubit = context.read<MapSearchCubit>();

    return ListTile(
      dense: true,
      title: Text(
        result.mainText,
        style: const TextStyle(color: ConstColors.mapText),
      ),
      subtitle: Text(
        result.secondaryText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: ConstColors.mapText, fontWeight: FontWeight.w400),
      ),
      onTap: () async {
        mapSearchCubit.searchController.text = result.mainText;
        mapSearchCubit.unFocusSearch();
        mapCubit.selectPlaceFromResults(result);
        final LatLng location = await mapSearchCubit.getLatLngFromPlaceId(result.placeId);
        mapOverlayControlsCubit.getPlaceTitle(location);
      },
    );
  }
}
