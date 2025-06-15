import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.hardEdge,
      color: isDarkMode ? ConstColors.darkPrimary : Colors.white,
      elevation: isDarkMode ? 4 : 2,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: isDarkMode
                            ? ConstColors.drawerTileDark
                            : ConstColors.drawerTile,
                      ),
                    ),
                  )
                : Container(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    child: Icon(
                      Icons.image,
                      color: isDarkMode
                          ? ConstColors.drawerTileDark
                          : ConstColors.drawerTile,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDarkMode ? Colors.white : ConstColors.primaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
