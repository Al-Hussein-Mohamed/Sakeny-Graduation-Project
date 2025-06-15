import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/core/utils/helpers/quick_bouncing_scrool_physics.dart';
import 'package:sakeny/features/post/posts/controllers/post_cubit.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/post/posts/screens/post_widget.dart';
import 'package:sakeny/features/post/posts/widgets/post_shimmer_widget.dart';
import 'package:sakeny/features/profile/profile/controllers/profile_cubit.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';
import 'package:sakeny/features/profile/profile/screens/widgets/user_info_and_controls.dart';
import 'package:sakeny/generated/l10n.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.profileArgs});

  final ProfileArgs profileArgs;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GlobalKey<ScaffoldState> profileScaffoldKey;

  @override
  void initState() {
    profileScaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  void _onFloatingActionButtonPressed() {
    ProfileCubit.of(context).setEditing(false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return CustomScaffold(
          scaffoldKey: profileScaffoldKey,
          screenTitle: widget.profileArgs.userName,
          openDrawer: () => profileScaffoldKey.currentState?.openEndDrawer(),
          onBack: () => Navigator.pop(context),
          body: _ProfileBody(profileArgs: widget.profileArgs),
          floatingActionButton: state.isEditing
              ? FloatingActionButton(
                  onPressed: _onFloatingActionButtonPressed,
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.clear, color: Colors.white),
                )
              : null,
        );
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.profileArgs,
  });

  final ProfileArgs profileArgs;

  @override
  Widget build(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    final state = postCubit.state;
    final bool hasReachedMax = state is PostLoaded ? state.hasReachedMax : true;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        if (!hasReachedMax &&
            scrollNotification.metrics.pixels > scrollNotification.metrics.maxScrollExtent - 500) {
          postCubit.loadProfilePosts();
        }
        return false;
      },
      child: CustomScrollView(
        physics: const QuickBouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: UserInfoAndControls(profileArgs: profileArgs),
            ),
          ),
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              switch (state) {
                case PostLoading():
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(childCount: 4, (context, index) {
                      return const PostShimmerWidget();
                    }),
                  );

                case PostLoaded():
                  return _LoadedPostBody(
                    posts: state.posts,
                    hasReachedMax: state.hasReachedMax,
                    isMyProfile: profileArgs.myProfile,
                  );

                case PostFailure():
                  return SliverToBoxAdapter(
                    child: Text(state.error),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LoadedPostBody extends StatelessWidget {
  const _LoadedPostBody({
    required this.posts,
    required this.hasReachedMax,
    required this.isMyProfile,
  });

  final List<PostModel> posts;
  final bool hasReachedMax;
  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    final profileCubit = ProfileCubit.of(context);

    return posts.isEmpty
        ? _EmptyPostList(
            isMyProfile: isMyProfile,
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: posts.length + 1,
              (context, index) {
                if (index < posts.length) {
                  return PostWidget(
                    isEditing: profileCubit.state.isEditing,
                    key: ValueKey<String>(
                      "${posts[index].postId}_${posts[index].isFavorite}",
                    ),
                    post: posts[index],
                    index: index,
                  );
                }

                return AnimatedCrossFade(
                  duration: const Duration(milliseconds: 800),
                  firstChild: const PostShimmerWidget(),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState:
                      hasReachedMax ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                );
              },
            ),
          );
  }
}

class _EmptyPostList extends StatelessWidget {
  const _EmptyPostList({required this.isMyProfile});

  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: ConstConfig.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ConstImages.profileEmptyPosts,
                width: 90,
                height: 90,
                colorFilter: ColorFilter.mode(
                  CustomColorScheme.getColor(context, CustomColorScheme.text),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                lang.profileEmptyPostsTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              if (isMyProfile)
                Text(
                  lang.profileEmptyPostsMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CustomColorScheme.getColor(context, CustomColorScheme.drawerTile),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
