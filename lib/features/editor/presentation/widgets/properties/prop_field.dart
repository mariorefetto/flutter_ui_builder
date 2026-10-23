import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/edge_insets_value.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/asset_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/color_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/committed_text_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/edge_insets_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/icon_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/screen_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/value_format.dart';

/// Editor for the value of one property, chosen by the PropType of its schema.
/// The name is shown beside it by the properties panel.
class PropField extends StatelessWidget {
  const PropField({
    required this.schema,
    required this.props,
    required this.onChanged,
    super.key,
  });

  final PropSchema schema;

  /// Current values with defaults applied.
  final NodeProps props;

  /// Called with the new value, or null to restore the default.
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) => switch (schema.type) {
    PropType.string
        when schema.assetPicker && props.choice('source') == 'asset' =>
      AssetField(value: props.string(schema.name), onChanged: onChanged),
    PropType.string when schema.componentPicker => ScreenField(
      components: true,
      value: props.string(schema.name),
      onChanged: onChanged,
    ),
    PropType.string when schema.screenPicker => ScreenField(
      value: props.string(schema.name),
      onChanged: onChanged,
    ),
    PropType.string => CommittedTextField(
      text: props.string(schema.name) ?? '',
      onCommit: (text) {
        onChanged(text);
        return true;
      },
    ),
    PropType.number => CommittedTextField(
      text: _numberText(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onCommit: _commitNumber,
    ),
    PropType.boolean => Align(
      alignment: Alignment.centerLeft,
      child: Switch(
        value: props.boolean(schema.name) ?? false,
        onChanged: onChanged,
      ),
    ),
    PropType.color => ColorField(
      value: props.color(schema.name),
      onChanged: onChanged,
    ),
    PropType.choice => schema.iconPicker ? _icon() : _choice(context),
    PropType.edgeInsets => EdgeInsetsField(
      value: props.edgeInsets(schema.name),
      onChanged: (EdgeInsetsValue? value) => onChanged(
        value == null
            ? null
            : [value.left, value.top, value.right, value.bottom],
      ),
    ),
  };

  String _numberText() {
    final value = props.number(schema.name);
    return value == null ? '' : formatNumber(value);
  }

  bool _commitNumber(String text) {
    if (text.trim().isEmpty) {
      onChanged(null);
      return true;
    }
    final value = parseNumber(text);
    // A whole number property rejects 2.5 instead of silently rounding it.
    if (value == null || (schema.integer && value != value.roundToDouble())) {
      return false;
    }
    onChanged(schema.integer ? value.round() : value);
    return true;
  }

  Widget _icon() => IconField(
    value: props.choice(schema.name),
    clearable: schema.defaultValue == null,
    onChanged: onChanged,
  );

  Widget _choice(BuildContext context) {
    final current = props.choice(schema.name);
    return AppSelect<String>(
      key: ValueKey(current),
      value: current,
      hint: context.l10n.editorValueUnset,
      options: [
        if (schema.defaultValue == null)
          AppSelectOption(value: null, label: context.l10n.editorValueUnset),
        for (final option in schema.options)
          AppSelectOption(value: option, label: option),
      ],
      onChanged: onChanged,
    );
  }
}
