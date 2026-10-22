import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';

/// Small label that follows the pointer while dragging.
class DragFeedback extends StatelessWidget {
  const DragFeedback({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Material(
      color: colors.primaryContainer,
      borderRadius: context.radiusSM,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingSM),
        child: Text(label, style: TextStyle(color: colors.onPrimaryContainer)),
      ),
    );
  }
}
