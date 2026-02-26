import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Small purple circular badge showing extra count (e.g. +2).
/// Overlaps the top-right corner of the thumbnail.
class ExpandableImageBadge extends StatelessWidget {
  const ExpandableImageBadge({
    super.key,
    required this.count,
    this.size = 18,
    this.fontSize = 9,
  });

  /// Number of additional items (e.g. 2 for "+2").
  final int count;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
      ),
    );
  }
}
