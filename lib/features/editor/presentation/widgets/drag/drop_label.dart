import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';

/// A small tag that says where a drop would land: "Inside Column".
class DropLabel extends StatelessWidget {
  const DropLabel({required this.text, required this.color, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSM,
          vertical: AppConstants.spacingXS,
        ),
        child: Text(
          text,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
