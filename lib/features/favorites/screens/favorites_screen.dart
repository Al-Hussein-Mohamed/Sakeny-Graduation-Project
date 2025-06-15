import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/core/utils/helpers/quick_bouncing_scrool_physics.dart';
import 'package:sakeny/features/post/posts/controllers/post_cubit.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/post/posts/screens/post_widget.dart';
import 'package:sakeny/features/post/posts/widgets/post_shimmer_widget.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final Set<PostModel> selectedPosts = <PostModel>{};
  bool isSelectionMode = false;

  // Add ScrollController to maintain scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelection(PostModel post) {
    setState(() {
      if (selectedPosts.contains(post)) {
        selectedPosts.remove(post);
        // Don't automatically exit selection mode when no posts are selected
        // Keep selection mode active until user explicitly cancels via FAB
      } else {
        if (selectedPosts.length < 2) {
          selectedPosts.add(post);
          isSelectionMode = true;
        }
      }
    });
  }

  void _navigateToCompare() {
    if (selectedPosts.length == 2) {
      final S lang = S.of(context);
      final post1 = selectedPosts.first;
      final post2 = selectedPosts.last;

      // Check if both units are of the same type
      if (post1.unit.unitType != post2.unit.unitType) {
        ToastificationService.showToast(
          context,
          ToastificationType.error,
          lang.sameUnitTypeRequired, // You'll need to add this to your localization
          null,
        );
        return;
      }

      Navigator.pushNamed(
        context,
        PageRouteNames.compare,
        arguments: selectedPosts.toList(),
      );
    }
  }

  // Updated method to handle FAB press with different states
  void _onFloatingActionButtonPressed() {
    final S lang = S.of(context);
    if (selectedPosts.length == 2) {
      // Navigate to compare screen
      _navigateToCompare();
    } else if (isSelectionMode) {
      // Exit selection mode (cancel)
      _exitSelectionMode(lang);
    } else {
      // Start selection mode
      setState(() {
        isSelectionMode = true;
      });

      ToastificationService.showToast(
        context,
        ToastificationType.info,
        lang.selectTwoPostsToCompare,
        null,
      );
    }
  }

  // Method to exit selection mode
  void _exitSelectionMode(S lang) {
    setState(() {
      selectedPosts.clear();
      isSelectionMode = false;
    });

    ToastificationService.showToast(
      context,
      ToastificationType.info,
      lang.selectionCancelled,
      null,
    );
  }

  // Helper method to get FAB icon based on current state
  IconData _getFABIcon() {
    if (selectedPosts.length == 2) {
      return Icons.check; // Ready to compare
    } else if (isSelectionMode) {
      return Icons.close; // Cancel selection
    } else {
      return Icons.compare; // Start comparison
    }
  }

  // Helper method to get FAB color based on current state
  Color _getFABColor(BuildContext context) {
    if (selectedPosts.length == 2) {
      return Theme.of(context).primaryColor; // Ready to compare
    } else if (isSelectionMode) {
      return Colors.red; // Cancel selection
    } else {
      return Theme.of(context).primaryColor; // Start comparison
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final S lang = S.of(context);

    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        // Determine if FAB should be shown
        final shouldShowFAB = state is PostLoaded && state.posts.length >= 2;

        return CustomScaffold(
          scaffoldKey: scaffoldKey,
          screenTitle: lang.favorites,
          openDrawer: () => scaffoldKey.currentState?.openEndDrawer(),
          onBack: () {
            if (isSelectionMode) {
              _exitSelectionMode(lang);
            } else {
              Navigator.pop(context);
            }
          },
          body: _FavoritesScreenBody(
            selectedPosts: selectedPosts,
            isSelectionMode: isSelectionMode,
            onPostTap: _toggleSelection,
            scrollController: _scrollController, // Pass the scroll controller
          ),
          floatingActionButton: shouldShowFAB
              ? FloatingActionButton(
                  onPressed: _onFloatingActionButtonPressed,
                  shape: const CircleBorder(),
                  backgroundColor: _getFABColor(context),
                  elevation: selectedPosts.length == 2 ? 8.0 : 4.0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _getFABIcon(),
                      key: ValueKey(_getFABIcon()),
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _FavoritesScreenBody extends StatelessWidget {
  const _FavoritesScreenBody({
    required this.selectedPosts,
    required this.isSelectionMode,
    required this.onPostTap,
    required this.scrollController,
  });

  final Set<PostModel> selectedPosts;
  final bool isSelectionMode;
  final void Function(PostModel) onPostTap;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state) {
          case PostLoading():
            return ListView.builder(
              controller: scrollController,
              physics: const QuickBouncingScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) => const PostShimmerWidget(),
            );

          case PostLoaded():
            return _FavoritesLoaded(
              favorites: state.posts,
              hasReachedMax: state.hasReachedMax,
              selectedPosts: selectedPosts,
              isSelectionMode: isSelectionMode,
              onPostTap: onPostTap,
              scrollController: scrollController,
            );
          case PostFailure():
            return Center(
              child: Text(state.error),
            );
        }
      },
    );
  }
}

class _FavoritesLoaded extends StatelessWidget {
  const _FavoritesLoaded({
    required this.favorites,
    required this.hasReachedMax,
    required this.selectedPosts,
    required this.isSelectionMode,
    required this.onPostTap,
    required this.scrollController,
  });

  final List<PostModel> favorites;
  final bool hasReachedMax;
  final Set<PostModel> selectedPosts;
  final bool isSelectionMode;
  final void Function(PostModel) onPostTap;
  final ScrollController scrollController;

  // Helper method to get the selection number (1 or 2)
  int _getSelectionNumber(PostModel post, Set<PostModel> selectedPosts) {
    final List<PostModel> selectedList = selectedPosts.toList();
    final int index = selectedList.indexOf(post);
    return index + 1; // Return 1-based index
  }

  @override
  Widget build(BuildContext context) {
    final PostCubit postCubit = context.read<PostCubit>();
    return favorites.isEmpty
        ? const _EmptyFavoritesList()
        : NotificationListener(
            onNotification: (ScrollNotification scrollNotification) {
              if (!hasReachedMax &&
                  scrollNotification.metrics.pixels >
                      scrollNotification.metrics.maxScrollExtent - 1000) {
                postCubit.loadFavoritesPosts();
              }

              return false;
            },
            child: ListView.builder(
              key: const PageStorageKey<String>(
                'favorites_list',
              ),
              // Use PageStorageKey to solve the problem of screen getting rebuild every tap
              controller: scrollController,
              physics: const QuickBouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 20),
              itemCount: favorites.length + 1,
              itemBuilder: (context, index) {
                if (index < favorites.length) {
                  final post = favorites[index];
                  final isSelected = selectedPosts.contains(post);

                  return GestureDetector(
                    onTap: isSelectionMode ? () => onPostTap(post) : null,
                    child: Stack(
                      children: [
                        Container(
                          // Remove AnimatedContainer
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AbsorbPointer(
                            absorbing: isSelectionMode,
                            child: PostWidget(
                              key: ValueKey<String>("${post.postId}"), // Simplified key
                              post: post,
                              index: index,
                            ),
                          ),
                        ),
                        // Show selection indicator when in selection mode
                        if (isSelectionMode)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.withValues(alpha: 0.7),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                isSelected ? Icons.check : Icons.add,
                                color: Colors.white,
                                size: isSelected ? 20 : 16,
                              ),
                            ),
                          ),

                        // Show number indicator on the left side when post is selected
                        if (isSelectionMode && isSelected)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 40,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).primaryColor,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${_getSelectionNumber(post, selectedPosts)}/2',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
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

class _EmptyFavoritesList extends StatelessWidget {
  const _EmptyFavoritesList();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Center(
      child: Padding(
        padding: ConstConfig.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ConstImages.emptyFavorites,
              width: 150,
              height: 150,
              colorFilter: ColorFilter.mode(
                CustomColorScheme.getColor(context, CustomColorScheme.text),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              lang.addToFavorites,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              lang.addToFavoritesMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: CustomColorScheme.getColor(context, CustomColorScheme.drawerTile),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
