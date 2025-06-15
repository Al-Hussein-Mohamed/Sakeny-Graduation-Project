part of '../map_select_location_screen.dart';

class _OverlayControls extends StatelessWidget {
  const _OverlayControls();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 22,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AddressBar(),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _SelectButton()),
              SizedBox(width: 12),
              _GetCurrentLocationButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectButton extends StatelessWidget {
  const _SelectButton();

  @override
  Widget build(BuildContext context) {
    final MapSelectLocationCubit mapCubit = context.read<MapSelectLocationCubit>();
    final lang = S.of(context);

    return BlocBuilder<MapOverlayControlsCubit, MapOverlayControlsState>(
      builder: (context, state) {
        final bool isEnabled = state is MapOverlayControlsLoaded && state.address != null;

        return Hero(
          tag: ConstConfig.authButtonTag,
          child: ElevatedButton(
            onPressed: isEnabled ? () => mapCubit.selectLocation(context) : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: ConstColors.primaryElevatedButtonBackground,
              disabledBackgroundColor: ConstColors.primaryElevatedButtonDisabledBackground,
            ),
            child: Text(lang.select),
          ),
        );
      },
    );
  }
}
