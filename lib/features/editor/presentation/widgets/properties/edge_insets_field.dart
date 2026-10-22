import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/committed_text_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/value_format.dart';

/// Four number fields (left, top, right, bottom) for an edgeInsets property.
class EdgeInsetsField extends StatelessWidget {
  const EdgeInsetsField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Null when the property is not set.
  final EdgeInsetsValue? value;

  /// Called with the new insets, or null to clear the property.
  final ValueChanged<EdgeInsetsValue?> onChanged;

  @override
  Widget build(BuildContext context) {
    final current =
        value ?? const EdgeInsetsValue(left: 0, top: 0, right: 0, bottom: 0);
    final l10n = context.l10n;
    return Column(
      children: [
        _row(
          _side(
            l10n.editorInsetLeft,
            value?.left,
            (v) => current.copyWith(left: v),
          ),
          _side(
            l10n.editorInsetTop,
            value?.top,
            (v) => current.copyWith(top: v),
          ),
        ),
        _row(
          _side(
            l10n.editorInsetRight,
            value?.right,
            (v) => current.copyWith(right: v),
          ),
          _side(
            l10n.editorInsetBottom,
            value?.bottom,
            (v) => current.copyWith(bottom: v),
          ),
        ),
      ],
    );
  }

  Widget _row(Widget first, Widget second) => Padding(
    padding: const EdgeInsets.only(bottom: AppConstants.spacingXS),
    child: Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: AppConstants.spacingXS),
        Expanded(child: second),
      ],
    ),
  );

  Widget _side(
    String label,
    double? side,
    EdgeInsetsValue Function(double) update,
  ) => CommittedTextField(
    text: side == null ? '' : formatNumber(side),
    label: label,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onCommit: (text) {
      final parsed = text.trim().isEmpty ? 0.0 : parseNumber(text);
      if (parsed == null) return false;
      onChanged(update(parsed));
      return true;
    },
  );
}
