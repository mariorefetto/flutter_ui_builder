import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/component_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/component_binding.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/component_scope.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';

/// Components drawn inside one another deeper than this are cut off.
const int _maxDepth = 8;

/// The preview of a use of a component: the component itself, drawn where it
/// is used. What is inside it cannot be picked here, only the use as a whole;
/// to change it, the component is opened.
final Map<String, PreviewBuilder> componentPreviews = {
  componentType: (context, props, children) {
    final name = props.string(componentProp);
    final scope = ComponentScope.maybeOf(context);
    final root = name == null ? null : scope?.roots[name];
    if (scope == null || root == null || scope.depth >= _maxDepth) {
      return _Missing(name: name);
    }
    // The component as this use gives its parameters their values.
    final bound = bindArguments(
      root,
      scope.params[name] ?? const [],
      props.withPrefix(argumentPrefix),
    );
    return IgnorePointer(
      child: ComponentScope(
        roots: scope.roots,
        params: scope.params,
        build: scope.build,
        depth: scope.depth + 1,
        child: Builder(builder: (inner) => scope.build(inner, bound)),
      ),
    );
  },
};

/// Stands in for a component that is not there, or is too deep.
class _Missing extends StatelessWidget {
  const _Missing({required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.error),
        borderRadius: BorderRadius.circular(AppConstants.radiusSM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingSM),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.component, size: AppConstants.spacingMD),
            const SizedBox(width: AppConstants.spacingSM),
            Text(name ?? '', style: context.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
