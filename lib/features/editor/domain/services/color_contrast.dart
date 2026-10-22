import 'dart:math' as math;

const double _maxChannel = 255;
const double _lowThreshold = 0.03928;
const double _lowDivisor = 12.92;
const double _offset = 0.055;
const double _scale = 1.055;
const double _gamma = 2.4;
const double _redWeight = 0.2126;
const double _greenWeight = 0.7152;
const double _blueWeight = 0.0722;
const double _flare = 0.05;
const int _redShift = 16;
const int _greenShift = 8;
const int _channelMask = 0xFF;

/// The contrast ratio WCAG asks of normal text against its background.
const double minimumTextContrast = 4.5;

double _linear(int channel) {
  final value = channel / _maxChannel;
  return value <= _lowThreshold
      ? value / _lowDivisor
      : math.pow((value + _offset) / _scale, _gamma).toDouble();
}

/// The relative luminance of an ARGB color, from 0 (black) to 1 (white).
double relativeLuminance(int argb) {
  final red = _linear((argb >> _redShift) & _channelMask);
  final green = _linear((argb >> _greenShift) & _channelMask);
  final blue = _linear(argb & _channelMask);
  return _redWeight * red + _greenWeight * green + _blueWeight * blue;
}

/// The WCAG contrast ratio of two colors, from 1 (the same) to 21.
double contrastRatio(int first, int second) {
  final a = relativeLuminance(first);
  final b = relativeLuminance(second);
  final lighter = math.max(a, b);
  final darker = math.min(a, b);
  return (lighter + _flare) / (darker + _flare);
}
