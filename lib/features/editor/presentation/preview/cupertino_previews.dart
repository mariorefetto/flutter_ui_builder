import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/scaffold_definitions.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/node_props.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_builder.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_helpers.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';

void _noop() {}

void _noopChanged(Object? value) {}

// CupertinoButton rounds its corners by default, so a missing radius keeps
// that default instead of removing the rounding.
BorderRadius _buttonRadius(NodeProps props) =>
    radiusOf(props, 'borderRadius') ??
    BorderRadius.circular(AppConstants.radiusSM);

// CupertinoButton asserts that the pressed opacity is between 0 and 1.
double _pressedOpacity(NodeProps props) =>
    props.requiredNumber('pressedOpacity').clamp(0.0, 1.0);

/// Previews of the Cupertino widgets.
final Map<String, PreviewBuilder> cupertinoPreviews = {
  'CupertinoPageScaffold': _pageScaffold,
  'CupertinoNavigationBar': (context, props, children) =>
      CupertinoNavigationBar(
        middle: textOf(props, 'title'),
        backgroundColor: colorOf(props, 'backgroundColor'),
        previousPageTitle: props.string('previousPageTitle'),
      ),
  'CupertinoButton': (context, props, children) => inert(
    CupertinoButton(
      color: colorOf(props, 'color'),
      padding: insetsOf(props, 'padding'),
      borderRadius: _buttonRadius(props),
      pressedOpacity: _pressedOpacity(props),
      onPressed: _noop,
      child: requiredChild(children),
    ),
  ),
  'CupertinoButtonFilled': (context, props, children) => inert(
    CupertinoButton.filled(
      padding: insetsOf(props, 'padding'),
      borderRadius: _buttonRadius(props),
      pressedOpacity: _pressedOpacity(props),
      onPressed: _noop,
      child: requiredChild(children),
    ),
  ),
  'CupertinoSwitch': (context, props, children) => inert(
    CupertinoSwitch(
      value: props.boolean('value') ?? false,
      activeTrackColor: colorOf(props, 'activeTrackColor'),
      inactiveTrackColor: colorOf(props, 'inactiveTrackColor'),
      thumbColor: colorOf(props, 'thumbColor'),
      onChanged: _noopChanged,
    ),
  ),
  'CupertinoCheckbox': (context, props, children) => inert(
    CupertinoCheckbox(
      value: props.boolean('value') ?? false,
      activeColor: colorOf(props, 'activeColor'),
      checkColor: colorOf(props, 'checkColor'),
      onChanged: _noopChanged,
    ),
  ),
  'CupertinoSlider': _slider,
  'CupertinoActivityIndicator': (context, props, children) =>
      CupertinoActivityIndicator(
        radius: props.requiredNumber('radius'),
        color: colorOf(props, 'color'),
        animating: props.boolean('animating') ?? true,
      ),
  'CupertinoTextField': _textField,
  'CupertinoSearchTextField': (context, props, children) => inert(
    CupertinoSearchTextField(
      placeholder: props.string('placeholder'),
      backgroundColor: colorOf(props, 'backgroundColor'),
      enabled: props.boolean('enabled') ?? true,
    ),
  ),
  'CupertinoListTile': (context, props, children) => inert(
    CupertinoListTile(
      title: Text(props.requiredString('title')),
      subtitle: textOf(props, 'subtitle'),
      additionalInfo: textOf(props, 'additionalInfo'),
      leading: iconWidget(props, 'leading'),
      trailing: iconWidget(props, 'trailing'),
      backgroundColor: colorOf(props, 'backgroundColor'),
    ),
  ),
};

Widget _slider(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final min = props.requiredNumber('min');
  final max = props.requiredNumber('max') > min
      ? props.requiredNumber('max')
      : min + 1;
  final divisions = props.number('divisions')?.round();
  return inert(
    CupertinoSlider(
      value: props.requiredNumber('value').clamp(min, max),
      min: min,
      max: max,
      divisions: divisions != null && divisions > 0 ? divisions : null,
      activeColor: colorOf(props, 'activeColor'),
      thumbColor: colorOf(props, 'thumbColor') ?? CupertinoColors.white,
      onChanged: _noopChanged,
    ),
  );
}

Widget _textField(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final obscure = props.boolean('obscureText') ?? false;
  return inert(
    CupertinoTextField(
      placeholder: props.string('placeholder'),
      keyboardType: keyboardTypesByName[props.choice('keyboardType')],
      textAlign:
          enumOf(TextAlign.values, props, 'textAlign') ?? TextAlign.start,
      obscureText: obscure,
      // A hidden text field has one line.
      maxLines: obscure ? 1 : props.requiredNumber('maxLines').round(),
      maxLength: props.number('maxLength')?.round(),
      enabled: props.boolean('enabled') ?? true,
      readOnly: props.boolean('readOnly') ?? false,
      clearButtonMode:
          enumOf(OverlayVisibilityMode.values, props, 'clearButtonMode') ??
          OverlayVisibilityMode.never,
    ),
  );
}

// Drawn at a fixed screen size. The bar is laid out in a column because a
// wrapped bar is no longer the ObstructingPreferredSizeWidget the scaffold
// expects in its navigationBar slot.
Widget _pageScaffold(
  BuildContext context,
  NodeProps props,
  List<PreviewChild> children,
) {
  final bar = children
      .where((c) => cupertinoScaffoldLayout.slots.containsKey(c.type))
      .firstOrNull;
  final body = children
      .where((c) => !cupertinoScaffoldLayout.slots.containsKey(c.type))
      .firstOrNull;
  final screen = PreviewScreenScope.sizeOf(context);
  final insets = PreviewScreenScope.insetsOf(context);
  return SizedBox(
    width: screen.width,
    height: screen.height,
    child: ClipRect(
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(size: screen, padding: insets, viewPadding: insets),
        child: CupertinoPageScaffold(
          backgroundColor: colorOf(props, 'backgroundColor'),
          resizeToAvoidBottomInset:
              props.boolean('resizeToAvoidBottomInset') ?? true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (bar != null)
                // The bar reaches up under the status bar.
                SizedBox(
                  height: kMinInteractiveDimensionCupertino + insets.top,
                  child: bar.widget,
                ),
              Expanded(child: body?.widget ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    ),
  );
}
