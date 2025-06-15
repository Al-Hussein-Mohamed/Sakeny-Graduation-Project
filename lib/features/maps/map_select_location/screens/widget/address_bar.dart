part of '../map_select_location_screen.dart';

class _AddressBar extends StatelessWidget {
  const _AddressBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapOverlayControlsCubit, MapOverlayControlsState>(
      builder: (BuildContext context, MapOverlayControlsState state) {
        switch (state) {
          case MapOverlayControlsInitial():
            return const SizedBox.shrink();

          case MapOverlayControlsLoading():
            return const _AddressBarShimmer();

          case MapOverlayControlsLoaded():
            return _AddressBarBody(address: state.address!);

          case MapOverlayControlsError():
            return _AddressBarBody(address: state.message);
        }
      },
    );
  }
}

class _AddressBarShimmer extends StatelessWidget {
  const _AddressBarShimmer();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: ConstConfig.elevation,
      borderRadius: ConstConfig.borderRadius,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: ConstConfig.borderRadius,
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressBarBody extends StatelessWidget {
  const _AddressBarBody({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: ConstConfig.elevation,
      borderRadius: ConstConfig.borderRadius,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: ConstConfig.borderRadius,
        ),
        child: Text(
          address,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ConstColors.mapText),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    ;
  }
}
