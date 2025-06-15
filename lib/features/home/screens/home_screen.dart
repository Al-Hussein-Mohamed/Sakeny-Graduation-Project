import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/home/controllers/app_bar_positions.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/home/screens/widgets/custom_sliver_app_bar/custom_sliver_app_bar.dart';
import 'package:sakeny/features/post/posts/controllers/post_cubit.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/post/posts/screens/post_widget.dart';
import 'package:sakeny/features/post/posts/widgets/post_shimmer_widget.dart';
import 'package:sakeny/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _setUp(BuildContext context) async {
    final SettingsProvider settingsProvider = sl<SettingsProvider>();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final PostCubit postCubit = context.read<PostCubit>();

    settingsProvider.setSkipOnboarding();

    switch (homeCubit.user) {
      case GuestUser():
        postCubit.loadHomePosts(null);
        break;

      case AuthenticatedUser():
        _loadPosts();
        break;
    }
  }

  void _loadPosts() async {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final PostCubit postCubit = context.read<PostCubit>();
    await homeCubit.getUserData();
    await postCubit.loadHomePosts((homeCubit.user as AuthenticatedUser).userModel?.userId);
  }

  @override
  void initState() {
    super.initState();
    _setUp(context);
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return CustomScaffold(
      scaffoldKey: homeCubit.scaffoldKey,
      body: const HomeBody(),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   LocalNotificationServices.showNotification(title: 'Title', body: 'Body');
      // }),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final PostCubit postCubit = context.read<PostCubit>();
    final AppBarPositions appBarPositions = AppBarPositions.of(context);

    bool notificationListener(ScrollNotification scrollNotification) {
      appBarPositions.appBarListener(scrollNotification);

      // Pagination
      if (scrollNotification.metrics.pixels > scrollNotification.metrics.maxScrollExtent - 500) {
        postCubit.loadHomePosts(
          homeCubit.user is GuestUser
              ? null
              : (homeCubit.user as AuthenticatedUser).userModel?.userId,
        );
      }
      return false;
    }

    return Stack(
      children: [
        NotificationListener(
          onNotification: notificationListener,
          child: RefreshIndicator(
            onRefresh: () async => await postCubit.refreshPosts(homeCubit.user),
            displacement: 15,
            edgeOffset: appBarPositions.appBarMaxHeight,
            child: CustomScrollView(
              cacheExtent: 700,
              controller: appBarPositions.scrollController,
              // physics: const QuickBouncingScrollPhysics(),
              slivers: const [
                CustomSliverAppBar(),
                _HomeBody(),
              ],
            ),
          ),
        ),
        const CustomSliverAppBarComponents(),
      ],
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostFailure) {
          ToastificationService.somethingWentWrong(context);
        }
      },
      builder: (context, state) {
        switch (state) {
          case PostLoading():
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const PostShimmerWidget(),
                childCount: 4,
              ),
            );

          case PostLoaded():
            return _PostLoaded(
              posts: state.posts,
              hasReachedMax: state.hasReachedMax,
            );

          case PostFailure():
            final String error = state.error.isEmpty ? lang.toastErrorMessage : state.error;
            return SliverFillRemaining(child: Center(child: Text(error)));
        }
      },
    );
  }
}

class _PostLoaded extends StatelessWidget {
  const _PostLoaded({
    required this.posts,
    required this.hasReachedMax,
  });

  final List<PostModel> posts;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < posts.length) {
            return PostWidget(
              key: ValueKey<String>(posts[index].toString()),
              post: posts[index],
              index: index,
            );
          }

          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 800),
            sizeCurve: Curves.easeInOut,
            firstChild: const PostShimmerWidget(),
            secondChild: const SizedBox(height: 20),
            crossFadeState: hasReachedMax ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          );
        },
        childCount: posts.length + 1,
      ),
    );
  }
}
