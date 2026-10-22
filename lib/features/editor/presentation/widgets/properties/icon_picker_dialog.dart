import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/icon_names.dart';
import 'package:flutter_ui_builder/features/editor/presentation/editor_dimensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/icon_table.dart';

/// A dialog with every Material icon in a searchable grid. It pops with the
/// name of the icon chosen, or with null when cancelled.
class IconPickerDialog extends StatefulWidget {
  const IconPickerDialog({this.selected, super.key});

  /// The icon the property has now, shown highlighted.
  final String? selected;

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = _search.text.trim().toLowerCase().replaceAll(' ', '_');
    final names = query.isEmpty
        ? iconNames
        : iconNames.where((name) => name.contains(query)).toList();
    return AlertDialog(
      title: Text(l10n.iconPickerTitle),
      content: SizedBox(
        width: iconPickerWidth,
        height: iconPickerHeight,
        child: Column(
          children: [
            TextField(
              controller: _search,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.iconPickerSearch,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: iconTileSize,
                ),
                itemCount: names.length,
                itemBuilder: (context, index) => _IconTile(
                  name: names[index],
                  selected: names[index] == widget.selected,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.name, required this.selected});

  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: name,
      child: IconButton(
        isSelected: selected,
        icon: Icon(iconsByName[name]),
        onPressed: () => Navigator.of(context).pop(name),
      ),
    );
  }
}
