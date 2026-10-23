import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_theme.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/project_theme_data.dart';

void main() {
  test('an empty theme is the default Material 3 theme', () {
    final data = themeDataOf(const ProjectTheme());

    expect(data.useMaterial3, isTrue);
    expect(data.brightness, Brightness.light);
    expect(
      data.colorScheme.primary,
      ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)).primary,
    );
  });

  test('the seed and the brightness make the colour scheme', () {
    final data = themeDataOf(
      const ProjectTheme(
        parts: {
          'scheme': {'seedColor': 0xFF009688, 'brightness': 'dark'},
        },
      ),
    );

    expect(data.brightness, Brightness.dark);
    expect(
      data.colorScheme,
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF009688),
        brightness: Brightness.dark,
      ),
    );
    expect(
      themeIsDark(
        const ProjectTheme(
          parts: {
            'scheme': {'brightness': 'dark'},
          },
        ),
      ),
      isTrue,
    );
  });

  test('the theme of a widget reaches its theme data', () {
    final data = themeDataOf(
      const ProjectTheme(
        parts: {
          'appBar': {'backgroundColor': 0xFF112233, 'centerTitle': true},
          'card': {'elevation': 0.0, 'borderRadius': 16.0},
          'elevatedButton': {'foregroundColor': 0xFFFF0000},
          'divider': {'thickness': 3.0},
          'inputDecoration': {'border': 'outline', 'borderRadius': 8.0},
        },
      ),
    );

    expect(data.appBarTheme.backgroundColor, const Color(0xFF112233));
    expect(data.appBarTheme.centerTitle, isTrue);
    expect(data.cardTheme.elevation, 0);
    expect(
      data.cardTheme.shape,
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
    expect(
      data.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
      const Color(0xFFFF0000),
    );
    expect(data.dividerTheme.thickness, 3);
    expect(
      data.inputDecorationTheme.border,
      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  });

  test('the same theme gives the same data object', () {
    const theme = ProjectTheme(
      parts: {
        'scheme': {'seedColor': 0xFF009688},
      },
    );

    expect(
      identical(cachedThemeDataOf(theme), cachedThemeDataOf(theme)),
      isTrue,
    );
  });
}
