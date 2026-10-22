import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_field.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/properties/prop_help.dart';

/// How long the pointer rests on a name before its tooltip shows.
const Duration propTooltipDelay = Duration(milliseconds: 400);

const int _nameFlex = 2;
const int _editorFlex = 3;

/// One row of the properties panel: the name, the editor and a reset button
/// when the value differs from the default.
class PropRow extends StatelessWidget {
  const PropRow({
    required this.schema,
    required this.props,
    required this.modified,
    required this.focused,
    required this.onFocus,
    required this.onChanged,
    super.key,
  });

  final PropSchema schema;
  final NodeProps props;

  /// True when the node stores a value of its own for this property.
  final bool modified;
  final bool focused;
  final VoidCallback onFocus;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return ColoredBox(
      color: focused ? colors.secondaryContainer : colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSM,
          vertical: AppConstants.spacingXS,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: _nameFlex,
              child: Tooltip(
                richMessage: TextSpan(text: propTooltip(context.l10n, schema)),
                waitDuration: propTooltipDelay,
                child: InkWell(
                  onTap: onFocus,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingSM,
                    ),
                    child: Text(
                      schema.label ?? schema.name,
                      overflow: TextOverflow.ellipsis,
                      // A value set on the node is shown in bold.
                      style: modified
                          ? context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : context.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: _editorFlex,
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) onFocus();
                },
                child: PropField(
                  schema: schema,
                  props: props,
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(
              width: AppConstants.buttonHeightSmall,
              child: modified
                  ? IconButton(
                      tooltip: context.l10n.propsReset,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(AppIcons.reset),
                      onPressed: () => onChanged(null),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
