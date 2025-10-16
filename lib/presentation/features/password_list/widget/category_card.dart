
import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';

class CategoryCard extends StatelessWidget {

  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  const CategoryCard({super.key, required this.categoryName, required this.isSelected, required this.onTap, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return GestureDetector(
      onTap: () => onTap(),
      onDoubleTap: onDoubleTap,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: 30),
          child: Container(
            padding: EdgeInsets.fromLTRB(Sizes.spacingSm, 0,
                Sizes.spacingLg, 0),
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.only(left: Sizes.spacingMd),
            child: Text(categoryName),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isSelected ? colorScheme.primary.withOpacity(0.1) :colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
