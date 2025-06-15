import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/custom_elevated_button.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/text_fields/email_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/name_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/phone_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/select_location.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/navigation_service.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/features/Authentication/register/screens/widgets/profile_picture.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/maps/map_select_location/models/map_select_location_args.dart';
import 'package:sakeny/features/profile/edit_profile/controllers/edit_profile_cubit.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

part 'widget/edit_profile_body_comp.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final S lang = S.of(context);

    return CustomScaffold(
      scaffoldKey: editProfileCubit.scaffoldKey,
      screenTitle: lang.profileEdit,
      openDrawer: editProfileCubit.openDrawer,
      onBack: () => Navigator.pop(context),
      body: Form(
        key: editProfileCubit.formKey,
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccess) {
              homeCubit.getUserData();
              ToastificationService.showToast(
                context,
                ToastificationType.success,
                lang.profileSuccessfullyUpdatedTitle,
                lang.profileSuccessfullyUpdatedMessage,
              );
            } else if (state is EditProfileFailure) {
              ToastificationService.showToast(
                context,
                ToastificationType.success,
                lang.toastErrorTitle,
                lang.toastErrorMessage,
              );
            }
          },
          child: const SingleChildScrollView(
            physics: ConstConfig.scrollPhysics,
            padding: ConstConfig.screenPadding,
            child: _EditProfileBody(),
          ),
        ),
      ),
    );
  }
}

class _EditProfileBody extends StatelessWidget {
  const _EditProfileBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 10),
        _ProfilePicture(),
        SizedBox(height: 30),
        _FirstName(),
        SizedBox(height: 20),
        _SecondName(),
        SizedBox(height: 20),
        _PhoneNumber(),
        SizedBox(height: 20),
        _Email(),
        SizedBox(height: 20),
        _Location(),
        SizedBox(height: 20),
        _ChangePassword(),
        SizedBox(height: 20),
        _SaveButton(),
      ],
    );
  }
}
