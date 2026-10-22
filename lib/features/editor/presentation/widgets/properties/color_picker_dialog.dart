import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';

/// A dialog with a color area, hue and opacity sliders and a hex field. It
/// pops with the chosen color, or with null when cancelled.
class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({required this.initial, super.key});

  final Color initial;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _color = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.colorPickerTitle),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _color,
          onColorChanged: (color) => setState(() => _color = color),
          hexInputBar: true,
          labelTypes: const [],
          pickerAreaBorderRadius: BorderRadius.circular(AppConstants.radiusSM),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_color),
          child: Text(l10n.commonConfirm),
        ),
      ],
    );
  }
}
