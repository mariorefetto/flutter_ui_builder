import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/icon_table.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/icon_picker_dialog.dart';

/// An icon property: the icon and its name as a button that opens the picker,
/// and a clear button when the property may be empty.
class IconField extends StatelessWidget {
  const IconField({
    required this.value,
    required this.clearable,
    required this.onChanged,
    super.key,
  });

  /// The icon name, or null when the property is not set.
  final String? value;

  /// The property has no default, so it can be emptied.
  final bool clearable;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final name = value;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(name == null ? null : iconsByName[name]),
            label: Text(
              name ?? context.l10n.iconPickerNotSet,
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () => _pick(context),
          ),
        ),
        if (clearable)
          IconButton(
            tooltip: context.l10n.editorClearValue,
            icon: const Icon(AppIcons.clear),
            onPressed: name == null ? null : () => onChanged(null),
          )
        else
          const SizedBox(width: AppConstants.spacingXS),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (context) => IconPickerDialog(selected: value),
    );
    if (picked != null) onChanged(picked);
  }
}
