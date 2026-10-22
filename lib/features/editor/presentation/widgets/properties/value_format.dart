const int _hexRadix = 16;
const int _rgbDigits = 6;
const int _argbDigits = 8;
const int _opaqueAlpha = 0xFF000000;

/// Shows whole numbers without a fractional part (14.0 becomes 14).
String formatNumber(double value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

/// Parses a decimal number, returning null when [raw] is not one.
double? parseNumber(String raw) => double.tryParse(raw.trim());

/// Shows an ARGB color as eight hex digits.
String formatColor(int value) =>
    value.toRadixString(_hexRadix).toUpperCase().padLeft(_argbDigits, '0');

/// Parses RRGGBB (opaque) or AARRGGBB, with an optional leading '#'.
/// Returns null when [raw] is not a valid color.
int? parseColor(String raw) {
  final digits = raw.trim().replaceFirst('#', '');
  if (digits.length != _rgbDigits && digits.length != _argbDigits) return null;
  final value = int.tryParse(digits, radix: _hexRadix);
  if (value == null) return null;
  return digits.length == _rgbDigits ? _opaqueAlpha | value : value;
}
