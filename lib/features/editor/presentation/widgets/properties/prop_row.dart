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
    this.boundTo,
    this.onBind,
    this.onUnbind,
    super.key,
  });

  final PropSchema schema;
  final NodeProps props;

  /// True when the node stores a value of its own for this property.
  final bool modified;
  final bool focused;
  final VoidCallback onFocus;
  final ValueChanged<Object?> onChanged;

  /// The parameter of the open component this property is bound to.
  final String? boundTo;

  /// Binds the property to a parameter; null when it cannot be bound.
  final VoidCallback? onBind;
  final VoidCallback? onUnbind;

  // How many small buttons the row shows at its end: at least the room of
  // one, so the editors line up.
  int get _buttons {
    final count = boundTo != null
        ? 1
        : (onBind != null ? 1 : 0) + (modified ? 1 : 0);
    return count < 1 ? 1 : count;
  }

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
                child: boundTo == null
                    ? PropField(
                        schema: schema,
                        props: props,
                        onChanged: onChanged,
                      )
                    : _Bound(name: boundTo!),
              ),
            ),
            SizedBox(
              width: AppConstants.buttonHeightSmall * _buttons,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (boundTo != null)
                    _MiniButton(
                      tooltip: context.l10n.paramUnbind,
                      icon: AppIcons.unlink,
                      onPressed: onUnbind,
                    )
                  else ...[
                    if (onBind != null)
                      _MiniButton(
                        tooltip: context.l10n.paramBind,
                        icon: AppIcons.link,
                        onPressed: onBind,
                      ),
                    if (modified)
                      _MiniButton(
                        tooltip: context.l10n.propsReset,
                        icon: AppIcons.reset,
                        onPressed: () => onChanged(null),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What a property bound to a parameter shows in place of its editor.
class _Bound extends StatelessWidget {
  const _Bound({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSM),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSM,
            vertical: AppConstants.spacingXS,
          ),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}

/// A button at the end of a row, as big as the room the row gives it whatever
/// the theme makes of an icon button.
class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size.square(AppConstants.buttonHeightSmall),
        maximumSize: const Size.square(AppConstants.buttonHeightSmall),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
