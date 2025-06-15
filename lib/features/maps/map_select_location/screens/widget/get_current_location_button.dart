part of '../map_select_location_screen.dart';

class _GetCurrentLocationButton extends StatelessWidget {
  const _GetCurrentLocationButton();

  @override
  Widget build(BuildContext context) {
    final MapSelectLocationCubit mapCubit = context.read<MapSelectLocationCubit>();
    final MapOverlayControlsCubit overlayControlsCubit = context.read<MapOverlayControlsCubit>();

    return BlocBuilder<MapOverlayControlsCubit, MapOverlayControlsState>(
      builder: (context, state) {
        final bool isLoading = state is MapOverlayControlsLoading;
        return FloatingActionButton(
          // mini: true,
          onPressed: isLoading
              ? null
              : () async {
                  final MapSelectLocationArgs? mapArgs =
                      await overlayControlsCubit.getCurrentPosition(context);
                  if (mapArgs == null) return;
                  mapCubit.animateToLocationAndMark(
                    location: mapArgs.location,
                    address: mapArgs.address,
                  );
                },
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
        );
      },
    );
  }
}

class EnableGpsDialog extends StatelessWidget {
  const EnableGpsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final colors = AppColors.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: ConstConfig.borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lang.enableGPS,
                style: theme.textTheme.titleLarge?.copyWith(color: ConstColors.lightTextTitle)),
            const SizedBox(height: 16),
            Text(
              lang.gpsDisabledMessage,
              style: theme.textTheme.bodyMedium?.copyWith(color: ConstColors.lightTextTitle),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildDialogButton(
                    context: context,
                    text: lang.cancel,
                    isPrimary: false,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildDialogButton(
                    context: context,
                    text: lang.openSettings,
                    isPrimary: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Geolocator.openLocationSettings();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required BuildContext context,
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: ConstConfig.borderRadius,
      child: InkWell(
        borderRadius: ConstConfig.borderRadius,
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isPrimary ? theme.colorScheme.primary : Colors.transparent,
            border: isPrimary ? null : Border.all(color: theme.colorScheme.primary),
            borderRadius: ConstConfig.borderRadius,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isPrimary ? Colors.white : theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
