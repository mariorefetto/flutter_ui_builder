import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/code_literals.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/color_picker_dialog.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/committed_text_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/value_format.dart';

/// Hex entry for a color property, with a swatch and a clear button.
class ColorField extends StatelessWidget {
  const ColorField({required this.value, required this.onChanged, super.key});

  /// ARGB value, or null when the property is not set.
  final int? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = value;
    return Row(
      children: [
        _Swatch(color: color, onPressed: () => _pick(context)),
        const SizedBox(width: AppConstants.spacingSM),
        Expanded(
          child: CommittedTextField(
            text: color == null ? '' : formatColor(color),
            hint: context.l10n.editorColorHint,
            onCommit: _commit,
          ),
        ),
        IconButton(
          tooltip: context.l10n.editorClearValue,
          icon: const Icon(AppIcons.clear),
          onPressed: color == null ? null : () => onChanged(null),
        ),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final initial = value.let(Color.new) ?? context.colorScheme.primary;
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(initial: initial),
    );
    if (picked != null) onChanged(picked.toARGB32());
  }

  bool _commit(String text) {
    if (text.trim().isEmpty) {
      onChanged(null);
      return true;
    }
    final parsed = parseColor(text);
    if (parsed == null) return false;
    onChanged(parsed);
    return true;
  }
}

/// The current color as a button that opens the picker. With no color set it
/// shows an empty frame.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.onPressed});

  final int? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final current = color;
    return Tooltip(
      message: context.l10n.colorPickerOpen,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox.square(
          dimension: AppConstants.spacingLG,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: current == null ? null : Color(current),
              border: Border.all(color: context.colorScheme.outline),
            ),
            child: current == null ? const Icon(AppIcons.theme) : null,
          ),
        ),
      ),
    );
  }
}
