import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class ComparisonSection extends StatelessWidget {
  const ComparisonSection({
    super.key,
    required this.title,
    required this.values,
    this.isRating = false,
  });

  final String title;
  final List<String> values;
  final bool isRating;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : ConstColors.primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? ConstColors.darkPrimary : ConstColors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: isRating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              values[0],
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : ConstColors.primaryColor,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          values[0],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : ConstColors.primaryColor,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? ConstColors.darkPrimary : ConstColors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: isRating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              values[1],
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : ConstColors.primaryColor,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          values[1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white
                                : ConstColors.primaryColor,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
