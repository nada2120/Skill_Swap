import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/theme/app_palette.dart';

class FilterButton extends StatelessWidget {
  final int activeFilters;
  final VoidCallback? onPressed;

  const FilterButton({super.key, this.activeFilters = 0, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.of(context).size.width;
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          height: width * 0.12, // responsive height
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'filter'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (activeFilters > 0) ...[
                SizedBox(width: width * 0.02),
                Container(
                  width: width * 0.055,
                  height: width * 0.055,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppPalette.primary,
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        '$activeFilters',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
