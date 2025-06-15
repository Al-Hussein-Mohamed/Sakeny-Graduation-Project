import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/features/favorites/compare/controllers/compare_cubit.dart';
import 'package:sakeny/features/favorites/compare/screens/widgets/compare_body.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/generated/l10n.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CompareCubit compareCubit = context.read<CompareCubit>();
    final S lang = S.of(context);
    final List<PostModel> postsToCompare =
        ModalRoute.of(context)?.settings.arguments as List<PostModel>? ?? [];

    return CustomScaffold(
      scaffoldKey: compareCubit.scaffoldKeyCompare,
      screenTitle: lang.compare,
      openDrawer: compareCubit.openDrawerCompare,
      onBack: () => Navigator.pop(context),
      body: postsToCompare.length == 2
          ? CompareBody(posts: postsToCompare)
          : Center(
              child: Text(
                lang.selectTwoPostsToCompare,
              ),
            ),
    );
  }
}
