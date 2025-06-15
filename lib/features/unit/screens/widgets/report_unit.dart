part of '../unit_screen.dart';

class _ReportUnit extends StatelessWidget {
  const _ReportUnit();

  void _onReportTap(BuildContext context) async {
    final S lang = S.of(context);
    final UnitCubit unitCubit = context.read<UnitCubit>();
    final int postId = InheritedUnit.postOf(context).postId;

    final ReportModel? report = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: RouteSettings(arguments: postId),
      builder: (context) => const ReportBottomSheet(),
    ) as ReportModel?;

    if (report != null) {
      unitCubit.reportUnit(report: report, lang: lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return InkWell(
      onTap: () => _onReportTap(context),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.report,
            color: Colors.red,
          ),
          const SizedBox(width: 8),
          Text(lang.report, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({super.key});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  int? idx;
  bool valid = false;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _onRadioTap(int? newIdx) {
    if (newIdx == null) return;
    if (idx == newIdx) return;
    setState(() => idx = newIdx);
    _checkValidation();
  }

  void _onDescriptionChanged(String? newValue) {
    _checkValidation();
  }

  void _onButtonPressed() {
    if (!valid) return;
    final int postId = ModalRoute.of(context)!.settings.arguments as int;

    Navigator.pop(
      context,
      ReportModel(
        postId: postId,
        problemType: idx!,
        description: descriptionController.text,
      ),
    );
  }

  void _checkValidation() {
    final bool newValidation = idx != null && descriptionController.text.isNotEmpty;
    if (valid == newValidation) return;
    setState(() => valid = newValidation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final List<String> tiles = [lang.verbalAbuse, lang.misleadingInformation, lang.other];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const _Header(),
          _Radio(idx: idx, onTap: _onRadioTap, tiles: tiles),
          _ReportTextField(
            descriptionController: descriptionController,
            onDescriptionChanged: _onDescriptionChanged,
          ),
          const SizedBox(height: 18),
          _ReportButton(onPressed: valid ? _onButtonPressed : null),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Column(
      children: [
        Container(
          width: 50,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        const SizedBox(height: 12),
        Text(lang.report, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        const Divider(thickness: .3, color: Colors.grey),
      ],
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({
    required this.idx,
    required this.onTap,
    required this.tiles,
  });

  final int? idx;
  final void Function(int? index) onTap;
  final List<String> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (int i = 0; i < tiles.length; i++)
          RadioListTile<int>(
            value: i,
            groupValue: idx,
            title: Text(tiles[i], style: theme.textTheme.bodyMedium),
            onChanged: onTap,
            activeColor: CustomColorScheme.getColor(context, CustomColorScheme.text),
            fillColor: WidgetStateProperty.resolveWith(
              (states) => CustomColorScheme.getColor(context, CustomColorScheme.text),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: ConstConfig.borderRadius,
            ),
            visualDensity: const VisualDensity(horizontal: -4.0),
          )
      ],
    );
  }
}

class _ReportTextField extends StatelessWidget {
  const _ReportTextField({
    required this.onDescriptionChanged,
    required this.descriptionController,
  });

  final void Function(String? newString) onDescriptionChanged;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding + 7),
      child: TextField(
        decoration: InputDecoration(hintText: lang.writeYourReport),
        controller: descriptionController,
        onChanged: onDescriptionChanged,
      ).withAutomaticDirection(),
    );
  }
}

class _ReportButton extends StatelessWidget {
  const _ReportButton({
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding),
      child: CustomElevatedButton(
        onPressed: onPressed,
        child: Text(lang.sendReport),
      ),
    );
  }
}
