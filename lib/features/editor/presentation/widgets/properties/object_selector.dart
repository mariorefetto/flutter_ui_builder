import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';

const String _indentUnit = '  ';

/// Drop-down at the top of the properties panel that lists every widget of
/// the document and selects the one chosen.
class ObjectSelector extends StatelessWidget {
  const ObjectSelector({
    required this.root,
    required this.selectedId,
    super.key,
  });

  final WidgetNode root;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditorCubit>();
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingSM),
      child: AppSelect<String>(
        key: ValueKey(selectedId),
        value: selectedId,
        hint: context.l10n.propsNoSelectionTitle,
        options: [
          for (final entry in _flatten(root, 0))
            AppSelectOption(
              value: entry.$1.id,
              label:
                  '${_indentUnit * entry.$2}${entry.$1.type}  (${entry.$1.id})',
            ),
        ],
        onChanged: cubit.select,
      ),
    );
  }

  List<(WidgetNode, int)> _flatten(WidgetNode node, int depth) => [
    (node, depth),
    for (final child in node.children) ..._flatten(child, depth + 1),
  ];
}
