part of '../screens/post_widget.dart';

class _PostImage extends StatelessWidget {
  const _PostImage({
    required this.index,
    required this.postId,
    required this.imageUrl,
    required this.cacheKey,
    required this.isFavorite,
    required this.isRented,
  });

  final String imageUrl;
  final String cacheKey;
  final int index;
  final int postId;
  final bool isFavorite;
  final bool isRented;

  void _goToUnitScreen(BuildContext context) {
    final PostModel post = InheritedPost.of(context);

    Navigator.pushNamed(context, PageRouteNames.unit, arguments: post);
  }

  @override
  Widget build(BuildContext context) {
    final PostCubit postCubit = PostCubit.of(context);

    return GestureDetector(
      onTap: () => _goToUnitScreen(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Stack(
          children: [
            _Image(imageUrl: imageUrl),
            FavoriteButton(
              index: index,
              postId: postId,
              isFavorite: isFavorite,
              bottomOffset: 10,
              rightOffset: 10,
              addToFavorites: postCubit.addPostToFavorites,
              removeFromFavorites: postCubit.removePostFromFavorites,
            ),
            if (isRented) const _Rented(),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = 169;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: imageHeight,
        width: double.infinity,
        key: ValueKey<String>(imageUrl),
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: imageHeight,
          color: ConstColors.primaryColor.withValues(alpha: 0.1),
        ),
        errorWidget: (context, url, error) => Container(
          color: ConstColors.primaryColor.withValues(alpha: 0.1),
          child: const Icon(
            Icons.error_outline,
            color: ConstColors.primaryColor,
          ),
        ),
        cacheKey: imageUrl,
        memCacheHeight: 1024,
        memCacheWidth: 1024,
      ),
    );
  }
}

class _Rented extends StatelessWidget {
  const _Rented();

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return Positioned(
      left: 10,
      bottom: 10,
      child: Material(
        elevation: ConstConfig.elevation,
        borderRadius: BorderRadius.circular(10),
        // shape: const CircleBorder(),
        color: ConstColors.postGreen,
        // color: Colors.white.withValues(alpha: .7),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                ConstImages.postRented,
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 12),
              Text(
                lang.rented,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.index,
    required this.postId,
    required this.isFavorite,
    required this.addToFavorites,
    required this.removeFromFavorites,
    required this.bottomOffset,
    this.leftOffset,
    this.rightOffset,
  });

  final int index;
  final int postId;
  final bool isFavorite;

  final double bottomOffset;
  final double? leftOffset;
  final double? rightOffset;

  final void Function({required int index}) addToFavorites;
  final void Function({required int index}) removeFromFavorites;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> with SingleTickerProviderStateMixin {
  late bool isFavorite;
  late AnimationController _favoriteAnimationController;
  late Animation<Color?> _favoriteColorAnimation;
  StreamSubscription? _favoriteSubscription;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;

    _favoriteAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _favoriteColorAnimation = ColorTween(
      begin: Colors.grey,
      end: Colors.red,
    ).animate(_favoriteAnimationController);

    if (isFavorite) {
      _favoriteAnimationController.value = 1.0;
    }

    _favoriteAnimationController.addListener(() {
      setState(() {});
    });

    _favoriteSubscription = PostSynchronizer.onFavoriteChanged
        .where((changedPostId) => changedPostId == widget.postId.toString())
        .listen(_onFavoriteExternalChange);
  }

  void _onFavoriteExternalChange(String postId) {
    final bool? newStatus = PostSynchronizer.getFavoriteStatus(postId);
    if (newStatus != null && newStatus != isFavorite) {
      setState(() {
        isFavorite = newStatus;
        if (isFavorite) {
          _favoriteAnimationController.forward();
        } else {
          _favoriteAnimationController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _favoriteAnimationController.dispose();
    _favoriteSubscription?.cancel();
    super.dispose();
  }

  void _toggleFavorite() {
    final HomeCubit homeCubit = context.read<HomeCubit>();

    if (homeCubit.user is GuestUser) {
      ToastificationService.showGlobalGuestLoginToast();
      return;
    }

    if (isFavorite) {
      widget.removeFromFavorites(index: widget.index);
    } else {
      widget.addToFavorites(index: widget.index);
    }

    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        _favoriteAnimationController.forward();
      } else {
        _favoriteAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: widget.rightOffset,
      left: widget.leftOffset,
      bottom: widget.bottomOffset,
      child: GestureDetector(
        onTap: _toggleFavorite,
        child: Material(
          elevation: ConstConfig.elevation,
          shape: const CircleBorder(),
          color: Colors.white.withValues(alpha: .7),
          child: Container(
            padding: const EdgeInsets.only(
              top: 4 * 1.2,
              bottom: 2 * 1.2,
              left: 5 * 1.2,
              right: 5 * 1.2,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(isFavorite),
                color: _favoriteColorAnimation.value,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
