import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/addrealstate/controllers/add_real_estate_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class AddImagesSection extends StatefulWidget {
  const AddImagesSection({super.key});

  @override
  State<AddImagesSection> createState() => _AddImagesSectionState();
}

class _AddImagesSectionState extends State<AddImagesSection> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final AddRealEstateCubit addRealEstateCubit = context.read<AddRealEstateCubit>();
    final S lang = S.of(context);

    final List<XFile> selected = await _picker.pickMultiImage();

    if (selected == addRealEstateCubit.images) return;

    if (addRealEstateCubit.images.length + selected.length > 10) {
      ToastificationService.showGlobalErrorToast(lang.maxImagesExceeded);
      return;
    }

    setState(() {
      addRealEstateCubit.images.addAll(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AddRealEstateCubit addRealEstateCubit = context.read<AddRealEstateCubit>();
    final lang = S.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? ConstColors.lightInputField
              : ConstColors.onScaffoldBackground,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            ConstImages.addHeaderPic,
            width: 137,
            height: 57,
          ),
          if (addRealEstateCubit.images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 80),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: addRealEstateCubit.images.length,
                  itemBuilder: (context, index) {
                    return _ImageItem(
                      index: index,
                      image: addRealEstateCubit.images[index],
                      onRemove: () {
                        setState(() => addRealEstateCubit.images.removeAt(index));
                      },
                    );
                  },
                ),
              ),
            ),
          TextButton(
            onPressed: _pickImages,
            style: TextButton.styleFrom(
              minimumSize: const Size(111, 30),
              backgroundColor: ConstColors.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(),
              ),
            ),
            child: Text(
              lang.addImages,
              style: Theme.of(context).brightness == Brightness.light
                  ? CustomTextTheme.lightTextTheme.bodySmall
                  : CustomTextTheme.darkTextTheme.bodySmall,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              lang.addImagesMessage,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  const _ImageItem({
    required this.image,
    required this.onRemove,
    required this.index,
  });

  final XFile image;
  final VoidCallback onRemove;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(image.path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 6,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.highlight_remove_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
