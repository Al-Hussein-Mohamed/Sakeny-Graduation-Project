import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/core/APIs/api_post.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/post/posts/controllers/post_synchronizer.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';
import 'package:sakeny/features/unit/models/reportModel.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';
import 'package:sakeny/features/unit/screens/widgets/inherited_unit.dart';
import 'package:sakeny/generated/l10n.dart';

part 'unit_state.dart';

class UnitCubit extends Cubit<UnitState> {
  UnitCubit({required this.unitId, required this.ownerId}) : super(const UnitLoading());

  final int unitId;
  final String ownerId;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void addUnitRate({
    required BuildContext context,
    required double rate,
    required PostModel post,
  }) async {
    final S lang = S.of(context);

    EasyLoading.show();
    try {
      await ApiPost.addUnitRate(unitId: unitId, rate: rate, ratedUserId: ownerId);
      final PostModel newPost = post.copyWith(unit: post.unit.copyWith(visitorRate: rate));
      PostSynchronizer.syncPost(newPost);
    } catch (e) {
      EasyLoading.showError(lang.easyLoadingFailed);
    } finally {
      EasyLoading.showSuccess(lang.easyLoadingSuccess);
    }
  }

  void reportUnit({
    required ReportModel report,
    required S lang,
  }) async {
    EasyLoading.show();

    final res = await ApiPost.reportPost(reportModel: report);
    res.fold(
      (l) => ToastificationService.showGlobalErrorToast(l.toString()),
      (r) => ToastificationService.showGlobalSuccessToast(lang.reportSuccess),
    );

    EasyLoading.dismiss();
  }

  void goToProfile({required BuildContext context}) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final UnitModel unit = InheritedUnit.of(context);

    final ProfileArgs profileArgs = ProfileArgs(
      userState: homeCubit.user,
      userId: ownerId,
      userName: unit.ownerName,
      userProfilePictureUrl: unit.ownerProfilePictureUrl,
      userRate: unit.ownerRate,
      heroTag: "${unit.ownerProfilePictureUrl}fromUnitScreen",
    );

    Navigator.pushNamed(context, PageRouteNames.profile, arguments: profileArgs);
  }
}
