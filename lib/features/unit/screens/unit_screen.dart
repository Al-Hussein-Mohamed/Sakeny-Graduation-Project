import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/custom_elevated_button.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/core/utils/extensions/dynamic_text_direction_extension.dart';
import 'package:sakeny/core/utils/extensions/dynamic_text_field_direction_extension.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/helpers/quick_bouncing_scrool_physics.dart';
import 'package:sakeny/features/chat/chat_screen/models/chat_args.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/maps/map_show_units/models/map_show_units_args.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/post/posts/widgets/rating_starts.dart';
import 'package:sakeny/features/unit/controllers/unit_cubit.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/reportModel.dart';
import 'package:sakeny/features/unit/models/service_model.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';
import 'package:sakeny/features/unit/screens/widgets/inherited_unit.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

part 'widgets/nearby_services_section.dart';
part 'widgets/owner_card.dart';
part 'widgets/property_info_section.dart';
part 'widgets/rate_unit.dart';
part 'widgets/report_unit.dart';
part 'widgets/service_item.dart';
part 'widgets/services_section.dart';
part 'widgets/unit_header.dart';

class UnitScreen extends StatelessWidget {
  const UnitScreen({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final UnitCubit unitCubit = context.read<UnitCubit>();
    return InheritedUnit(
      post: post,
      unit: post.unit,
      child: CustomScaffold(
        scaffoldKey: unitCubit.scaffoldKey,
        openDrawer: unitCubit.openDrawer,
        onBack: () => Navigator.pop(context),
        screenTitle: post.unit.unitType.getString(context),
        body: const _UnitBody(),
      ),
    );
  }
}

class _UnitBody extends StatelessWidget {
  const _UnitBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: QuickBouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding),
        child: Column(
          children: [
            _UnitHeader(),
            _PropertyInfoSection(),
            _ServicesSection(),
            _NearbyServicesSection(),
            _OwnerCard(),
            _RateUnit(),
            _ReportUnit(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
