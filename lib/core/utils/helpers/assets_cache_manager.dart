import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Asset cache manager for preloading and efficiently managing app assets
class AssetCacheManager {
  factory AssetCacheManager() => _instance;

  AssetCacheManager._internal();

  // Singleton instance
  static final AssetCacheManager _instance = AssetCacheManager._internal();

  // Cache status tracking
  final Map<String, bool> _cachedAssets = {};

  /// Map of cached assets with their status
  Map<String, bool> get cachedAssets => Map.unmodifiable(_cachedAssets);

  /// Total number of successfully cached assets
  int get cachedAssetsCount => _cachedAssets.values.where((cached) => cached).length;

  /// Initialize and cache all app assets using BuildContext
  Future<void> initialize(
    BuildContext context, {
    required List<String> images,
    required List<String> svgs,
    Map<String, Size>? sizedImages,
  }) async {
    final int totalAssets = images.length + (sizedImages?.length ?? 0) + svgs.length;
    debugPrint('🚀 Starting asset caching for $totalAssets assets...');

    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      // Cache everything in parallel for maximum efficiency
      await Future.wait([
        _cacheImages(context, images),
        if (sizedImages != null) _cacheSizedImages(context, sizedImages),
        _cacheSvgs(svgs),
      ]);

      stopwatch.stop();
      debugPrint('✅ All assets cached in ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('📊 Successfully cached $cachedAssetsCount/$totalAssets assets');
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ Asset caching incomplete after ${stopwatch.elapsedMilliseconds}ms: $e');
    }
  }

  /// Preload assets without requiring BuildContext (can be used during app initialization)
  Future<void> preloadAssets({
    required List<String> images,
    required List<String> svgs,
  }) async {
    final int totalAssets = images.length + svgs.length;
    debugPrint('🚀 Starting asset preloading for $totalAssets assets...');

    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      // Cache SVGs
      await _cacheSvgs(svgs);

      // Precache regular images
      await _precacheImagesWithoutContext(images);

      stopwatch.stop();
      debugPrint('✅ Assets preloaded in ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('📊 Successfully cached $cachedAssetsCount/$totalAssets assets');
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ Asset preloading incomplete after ${stopwatch.elapsedMilliseconds}ms: $e');
    }
  }

  /// Cache only sized images (can be called after context is available)
  Future<void> cacheSizedImagesOnly(BuildContext context, Map<String, Size>? sizedImages) async {
    if (sizedImages == null || sizedImages.isEmpty) return;

    debugPrint('📏 Caching ${sizedImages.length} sized images...');
    await _cacheSizedImages(context, sizedImages);
    debugPrint('✅ All sized images cached');
  }

  /// Precache images without using BuildContext
  Future<void> _precacheImagesWithoutContext(List<String> assets) async {
    if (assets.isEmpty) return;

    debugPrint('🖼️ Precaching ${assets.length} images without context...');

    final List<Future<void>> futures = [];

    for (final asset in assets) {
      _cachedAssets[asset] = false;

      futures.add(
        Future(() async {
          try {
            final Completer<void> completer = Completer<void>();
            // Use AssetImage instead of raw asset path
            final ImageProvider imageProvider = AssetImage(asset);

            final devicePixelRatio = ui.window.devicePixelRatio;
            final configuration = ImageConfiguration(
              devicePixelRatio: devicePixelRatio,
            );

            final ImageStreamListener listener = ImageStreamListener(
              (ImageInfo info, bool synchronousCall) {
                _cachedAssets[asset] = true;
                completer.complete();
              },
              onError: (dynamic exception, StackTrace? stackTrace) {
                debugPrint('❌ Failed to precache image $asset: $exception');
                completer.completeError(exception);
              },
            );

            final ImageStream stream = imageProvider.resolve(configuration)..addListener(listener);

            await completer.future.timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                stream.removeListener(listener);
                throw TimeoutException('Timed out loading $asset');
              },
            ).whenComplete(() => stream.removeListener(listener));
          } catch (e) {
            debugPrint('❌ Error precaching image $asset: $e');
          }
        }),
      );
    }

    await Future.wait(futures);
  }

  /// Cache all regular images
  Future<void> _cacheImages(BuildContext context, List<String> assets) async {
    if (assets.isEmpty) return;

    debugPrint('🖼️ Caching ${assets.length} images...');
    await Future.wait(
      assets.map((asset) => _cacheImage(context, asset)),
    );
  }

  /// Cache all images with specific sizes
  Future<void> _cacheSizedImages(BuildContext context, Map<String, Size> sizedAssets) async {
    if (sizedAssets.isEmpty) return;

    debugPrint('📏 Caching ${sizedAssets.length} sized images...');
    await Future.wait(
      sizedAssets.entries.map(
        (entry) => _cacheImageWithSize(context, entry.key, entry.value),
      ),
    );
  }

  /// Cache all SVG assets
  Future<void> _cacheSvgs(List<String> svgAssets) async {
    if (svgAssets.isEmpty) return;

    debugPrint('🔍 Caching ${svgAssets.length} SVG assets...');
    await Future.wait(
      svgAssets.map(_cacheSvg),
    );
  }

  /// Cache an individual image
  Future<void> _cacheImage(BuildContext context, String asset) async {
    _cachedAssets[asset] = false;

    try {
      // Use AssetImage to handle resolution variants automatically
      final ImageProvider imageProvider = AssetImage(asset);
      final MediaQueryData mediaQuery = MediaQuery.of(context);
      final ImageConfiguration config = createLocalImageConfiguration(
        context,
        // Explicitly include devicePixelRatio to ensure proper resolution variant is loaded
        size: null,
      );

      final ImageStream stream = imageProvider.resolve(config);
      final Completer<void> completer = Completer<void>();

      late final ImageStreamListener listener;

      listener = ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          _cachedAssets[asset] = true;
          completer.complete();
          stream.removeListener(listener);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          debugPrint('❌ Failed to cache image $asset: $exception');
          completer.completeError(exception);
          stream.removeListener(listener);
        },
      );

      stream.addListener(listener);
      return completer.future;
    } catch (e) {
      debugPrint('❌ Error caching image $asset: $e');
    }
  }

  /// Cache an individual image with specific size
  Future<void> _cacheImageWithSize(BuildContext context, String asset, Size size) async {
    _cachedAssets['$asset (${size.width}x${size.height})'] = false;

    try {
      // Use AssetImage to handle resolution variants automatically
      final ImageProvider imageProvider = AssetImage(asset);
      final ImageConfiguration config = createLocalImageConfiguration(
        context,
        size: size,
      );

      final ImageStream stream = imageProvider.resolve(config);
      final Completer<void> completer = Completer<void>();

      late final ImageStreamListener listener;

      listener = ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          _cachedAssets['$asset (${size.width}x${size.height})'] = true;
          completer.complete();
          stream.removeListener(listener);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          debugPrint('❌ Failed to cache sized image $asset: $exception');
          completer.completeError(exception);
          stream.removeListener(listener);
        },
      );

      stream.addListener(listener);
      return completer.future;
    } catch (e) {
      debugPrint('❌ Error caching sized image $asset: $e');
    }
  }

  /// Cache an individual SVG asset
  Future<void> _cacheSvg(String asset) async {
    _cachedAssets[asset] = false;

    try {
      final loader = SvgAssetLoader(asset);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
      _cachedAssets[asset] = true;
    } catch (e) {
      debugPrint('❌ Error caching SVG $asset: $e');
    }
  }

  /// Clear all cached assets
  void clearCache() {
    _cachedAssets.clear();
    PaintingBinding.instance.imageCache.clear();
    svg.cache.clear();
    debugPrint('🧹 Asset cache cleared');
  }
}
