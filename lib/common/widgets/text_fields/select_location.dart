import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/generated/l10n.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({
    super.key,
    required this.locationController,
    this.padding = ConstConfig.textFieldPadding,
    this.locationFocusNode,
    this.onTap,
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController locationController;
  final FocusNode? locationFocusNode;
  final void Function()? onTap;

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  bool isLocationValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final Color color = isLocationValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(context, ConstColors.lightWrongInputField, ConstColors.darkWrongInputField);
    final tap = widget.onTap != null;

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        readOnly: tap ? true : false,
        onTap: widget.onTap,
        controller: widget.locationController,
        focusNode: widget.locationFocusNode,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontSize: 17.spMin,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: ImageIcon(
            const AssetImage(ConstImages.locationIcon),
            color: color,
          ),
          suffixIcon: Icon(Icons.arrow_forward_ios_outlined, size: 24, color: color),
          label: Text(
            lang.location,
            style: TextStyle(color: color),
          ),
        ),
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.location],
        validator: (value) => _validateLocation(context, value),
      ),
    );
  }

  String? _validateLocation(BuildContext context, final String? value) {
    final S lang = S.of(context);
    String? res;
    if (value == null || value.trim().isEmpty) {
      res = lang.validators_locationRequired;
    }

    if ((res == null) != isLocationValid) {
      setState(() {
        isLocationValid = !isLocationValid;
      });
    }
    return res;
  }
}
