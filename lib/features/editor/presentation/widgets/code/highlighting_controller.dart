import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/code/dart_tokens.dart';

/// A text controller whose text is drawn in the colours of Dart source. It
/// colours only: the text, the selection and the editing are the field's own.
class HighlightingController extends TextEditingController {
  HighlightingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final colors = context.colorScheme;
    TextStyle? styleOf(TokenKind kind) => switch (kind) {
      TokenKind.plain => style,
      TokenKind.comment => style?.copyWith(
        color: colors.outline,
        fontStyle: FontStyle.italic,
      ),
      TokenKind.string => style?.copyWith(color: colors.tertiary),
      TokenKind.number => style?.copyWith(color: colors.secondary),
      TokenKind.keyword => style?.copyWith(
        color: colors.primary,
        fontWeight: FontWeight.w600,
      ),
      TokenKind.type => style?.copyWith(color: colors.secondary),
      TokenKind.annotation => style?.copyWith(color: colors.primary),
      TokenKind.argument => style?.copyWith(color: colors.onSurfaceVariant),
    };
    return TextSpan(
      style: style,
      children: [
        for (final token in tokenizeDart(text))
          TextSpan(text: token.text, style: styleOf(token.kind)),
      ],
    );
  }
}
