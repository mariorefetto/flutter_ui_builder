import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';

/// The picture an Image shows, picked from the project's pictures. A name that
/// is not among them is kept and shown, since the code may refer to a picture
/// the project does not list.
class AssetField extends StatelessWidget {
  const AssetField({required this.value, required this.onChanged, super.key});

  /// The picture's name, or null for none.
  final String? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final names = context.select(
      (EditorCubit c) => [for (final a in c.state.document.assets) a.name],
    );
    final current = value == null || value!.isEmpty ? null : value;
    return AppSelect<String>(
      value: current,
      hint: l10n.assetNone,
      options: [
        AppSelectOption(value: null, label: l10n.assetNone),
        for (final name in names) AppSelectOption(value: name, label: name),
        if (current != null && !names.contains(current))
          AppSelectOption(value: current, label: current),
      ],
      onChanged: onChanged,
    );
  }
}
