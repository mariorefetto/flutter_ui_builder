import 'package:flutter_ui_builder/features/editor/domain/definitions/decoration_code.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/prop_schema.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/code_value.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/value_reader.dart';

/// Reads the parts of a widget's constructor that its schema alone cannot
/// describe, writing what it finds into [props] and the names of the named
/// arguments it dealt with into [consumed].
typedef ImportHook =
    void Function(
      CodeCall call,
      ValueReader reader,
      List<PropSchema> schemas,
      Map<String, Object?> props,
      Set<String> consumed,
    );

/// The hooks of the widgets whose code is not derived from their schema.
final Map<String, ImportHook> importHooks = {
  'Container': _container,
  'DecoratedBox': _decoration,
  'Text': _text,
  'Image': _image,
  'Theme': _theme,
  'Icon': _icon,
};

CodeValue? _namedValue(CodeCall call, String name) => call.named[name];

void _put(Map<String, Object?> props, String name, Object? value) {
  if (value != null) props[name] = value;
}

// `decoration: BoxDecoration(...)` and `constraints: BoxConstraints(...)`.
void _container(
  CodeCall call,
  ValueReader reader,
  List<PropSchema> schemas,
  Map<String, Object?> props,
  Set<String> consumed,
) {
  _decoration(call, reader, schemas, props, consumed);
  final constraints = _namedValue(call, 'constraints');
  if (constraints is CodeCall) {
    consumed.add('constraints');
    for (final key in ['minWidth', 'maxWidth', 'minHeight', 'maxHeight']) {
      final value = _namedValue(constraints, key);
      _put(props, key, value == null ? null : reader.number(value));
    }
  }
}

// `decoration: BoxDecoration(color, gradient, borderRadius, border, boxShadow,
// shape)`, the shape the decoration properties are written in.
void _decoration(
  CodeCall call,
  ValueReader reader,
  List<PropSchema> schemas,
  Map<String, Object?> props,
  Set<String> consumed,
) {
  final decoration = _namedValue(call, 'decoration');
  if (decoration is! CodeCall) return;
  consumed.add('decoration');
  final color = _namedValue(decoration, 'color');
  _put(props, 'color', color == null ? null : reader.color(color));
  _gradient(_namedValue(decoration, 'gradient'), reader, props);
  _radius(_namedValue(decoration, 'borderRadius'), reader, props);
  _border(_namedValue(decoration, 'border'), reader, props);
  _shadow(_namedValue(decoration, 'boxShadow'), reader, props);
  final shape = _namedValue(decoration, 'shape');
  _put(props, 'shape', shape == null ? null : _member(shape, 'BoxShape'));
}

void _gradient(
  CodeValue? value,
  ValueReader reader,
  Map<String, Object?> props,
) {
  if (value is! CodeCall) return;
  final colors = _namedValue(value, 'colors');
  if (colors is CodeList && colors.items.length == 2) {
    _put(props, 'gradientStart', reader.color(colors.items[0]));
    _put(props, 'gradientEnd', reader.color(colors.items[1]));
  }
  final begin = _namedValue(value, 'begin');
  final end = _namedValue(value, 'end');
  for (final entry in gradientDirections.entries) {
    if (begin != null &&
        end != null &&
        _member(begin, 'Alignment') == entry.value.begin &&
        _member(end, 'Alignment') == entry.value.end) {
      props['gradientDirection'] = entry.key;
    }
  }
}

void _radius(CodeValue? value, ValueReader reader, Map<String, Object?> props) {
  if (value is! CodeCall) return;
  if (value.constructor == 'circular' && value.positional.isNotEmpty) {
    _put(props, 'borderRadius', reader.number(value.positional.first));
    return;
  }
  const corners = {
    'topLeft': 'radiusTopLeft',
    'topRight': 'radiusTopRight',
    'bottomLeft': 'radiusBottomLeft',
    'bottomRight': 'radiusBottomRight',
  };
  for (final MapEntry(:key, value: name) in corners.entries) {
    final corner = _namedValue(value, key);
    if (corner is CodeCall && corner.positional.isNotEmpty) {
      _put(props, name, reader.number(corner.positional.first));
    }
  }
}

void _border(CodeValue? value, ValueReader reader, Map<String, Object?> props) {
  if (value is! CodeCall) return;
  if (value.constructor == 'all') {
    _borderSide(value, reader, props, 'borderWidth');
    return;
  }
  for (final side in ['left', 'top', 'right', 'bottom']) {
    final part = _namedValue(value, side);
    if (part is CodeCall) {
      final name = 'border${side[0].toUpperCase()}${side.substring(1)}Width';
      _borderSide(part, reader, props, name);
    }
  }
}

// The color and width of `Border.all(...)` or one `BorderSide(...)`.
void _borderSide(
  CodeCall call,
  ValueReader reader,
  Map<String, Object?> props,
  String widthName,
) {
  final color = _namedValue(call, 'color');
  final width = _namedValue(call, 'width');
  _put(props, 'borderColor', color == null ? null : reader.color(color));
  _put(props, widthName, width == null ? null : reader.number(width));
}

void _shadow(CodeValue? value, ValueReader reader, Map<String, Object?> props) {
  if (value is! CodeList || value.items.isEmpty) return;
  final shadow = value.items.first;
  if (shadow is! CodeCall) return;
  final color = _namedValue(shadow, 'color');
  _put(props, 'shadowColor', color == null ? null : reader.color(color));
  final blur = _namedValue(shadow, 'blurRadius');
  _put(props, 'shadowBlur', blur == null ? null : reader.number(blur));
  final spread = _namedValue(shadow, 'spreadRadius');
  _put(props, 'shadowSpread', spread == null ? null : reader.number(spread));
  final offset = _namedValue(shadow, 'offset');
  if (offset is CodeCall && offset.positional.length == 2) {
    _put(props, 'shadowOffsetX', reader.number(offset.positional[0]));
    _put(props, 'shadowOffsetY', reader.number(offset.positional[1]));
  }
}

// `Text('...', style: TextStyle(...))`: the text comes first and the font
// settings live in the style.
void _text(
  CodeCall call,
  ValueReader reader,
  List<PropSchema> schemas,
  Map<String, Object?> props,
  Set<String> consumed,
) {
  _firstArgument('text')(call, reader, schemas, props, consumed);
  final style = _namedValue(call, 'style');
  if (style is! CodeCall) return;
  consumed.add('style');
  for (final MapEntry(:key, :value) in style.named.entries) {
    switch (key) {
      case 'fontSize' || 'letterSpacing' || 'height':
        _put(props, key, reader.number(value));
      case 'color':
        _put(props, key, reader.color(value));
      case 'fontFamily':
        if (value is CodeString) props[key] = value.value;
      case 'fontWeight':
        _put(props, key, _member(value, 'FontWeight'));
      case 'decoration':
        _put(props, key, _member(value, 'TextDecoration'));
      case 'fontStyle':
        if (_member(value, 'FontStyle') == 'italic') props['italic'] = true;
    }
  }
}

// `Icon(Icons.name, size: ..., color: ...)`.
void _icon(
  CodeCall call,
  ValueReader reader,
  List<PropSchema> schemas,
  Map<String, Object?> props,
  Set<String> consumed,
) {
  if (call.positional.isEmpty) return;
  _put(props, 'icon', _member(call.positional.first, 'Icons'));
}

// The first positional argument as a string property.
ImportHook _firstArgument(String name) =>
    (call, reader, schemas, props, consumed) {
      if (call.positional.isEmpty) return;
      final first = call.positional.first;
      if (first is CodeString) props[name] = first.value;
    };

// The member name of `Prefix.member`, or null.
String? _member(CodeValue value, String prefix) =>
    value is CodeIdentifier && value.prefix == prefix ? value.name : null;

// `Image.network('...')`, `Image.asset('...')` and `Image.file(File('...'))`.
void _image(
  CodeCall call,
  ValueReader reader,
  List<PropSchema> schemas,
  Map<String, Object?> props,
  Set<String> consumed,
) {
  final source = call.constructor;
  if (source == null || call.positional.isEmpty) return;
  props['source'] = source;
  final first = call.positional.first;
  final path =
      first is CodeCall && first.name == 'File' && first.positional.isNotEmpty
      ? first.positional.first
      : first;
  if (path is CodeString) props['url'] = path.value;
}

// `Theme(data: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: ...,
// brightness: ...)))`.
void _theme(
  CodeCall call,
  ValueReader reader,
  List<PropSchema> schemas,
  Map<String, Object?> props,
  Set<String> consumed,
) {
  final data = _namedValue(call, 'data');
  if (data is! CodeCall) return;
  consumed.add('data');
  final scheme = _namedValue(data, 'colorScheme');
  if (scheme is! CodeCall) return;
  final seed = _namedValue(scheme, 'seedColor');
  _put(props, 'seedColor', seed == null ? null : reader.color(seed));
  final brightness = _namedValue(scheme, 'brightness');
  _put(
    props,
    'brightness',
    brightness == null ? null : _member(brightness, 'Brightness'),
  );
}
