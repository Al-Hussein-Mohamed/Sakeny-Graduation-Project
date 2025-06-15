part of '../unit_screen.dart';

class _UnitHeader extends StatelessWidget {
  const _UnitHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final UnitModel unit = InheritedUnit.of(context);
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const _UnitImagesViewer(),
        const SizedBox(height: 10),
        Text(unit.title).withAutomaticDirectionAlign(),
        const SizedBox(height: 6),
        Text(unit.description, style: theme.textTheme.bodySmall).withAutomaticDirectionAlign(),
        const SizedBox(height: 12),
        const Divider(color: Colors.grey),
      ],
    );
  }
}

class _UnitImagesViewer extends StatefulWidget {
  const _UnitImagesViewer();

  @override
  State<_UnitImagesViewer> createState() => _UnitImagesViewerState();
}

class _UnitImagesViewerState extends State<_UnitImagesViewer> {
  int activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final UnitModel unit = InheritedUnit.of(context);
    final List<String> images = unit.unitPicturesUrls;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider.builder(
              carouselController: _controller,
              itemCount: images.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () => _showFullImage(context, images[index]),
                  child: _ImageView(imageUrl: images[index]),
                );
              },
              options: CarouselOptions(
                height: 200,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() => activeIndex = index);
                },
              ),
            ),
            PositionedDirectional(
              start: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            PositionedDirectional(
              end: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () => _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: images.length,
          effect: ExpandingDotsEffect(
            activeDotColor: getTextColor(context),
            dotColor: getTextColor(context).withOpacity(0.3),
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
          ),
          onDotClicked: (index) {
            _controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: _FullScreenImage(imageUrl: imageUrl),
        );
      },
    ));
  }
}

class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Hero(
              tag: "${imageUrl}unit",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  cacheKey: imageUrl,
                  key: ValueKey<String>(imageUrl),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageView extends StatelessWidget {
  const _ImageView({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = 169;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Hero(
        tag: "${imageUrl}unit",
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
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
        ),
      ),
    );
  }
}
