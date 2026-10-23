import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The shortcut for [key] with the platform's command modifier: the command
/// key on macOS and control elsewhere.
SingleActivator commandKey(LogicalKeyboardKey key, {bool shift = false}) {
  final isMac = defaultTargetPlatform == TargetPlatform.macOS;
  return SingleActivator(key, meta: isMac, control: !isMac, shift: shift);
}

/// Whether a key that adds to the selection is held: Cmd or Ctrl, or Shift.
bool get addsToSelection =>
    HardwareKeyboard.instance.isMetaPressed ||
    HardwareKeyboard.instance.isControlPressed ||
    HardwareKeyboard.instance.isShiftPressed;
