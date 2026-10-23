import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

Map<String, dynamic> _arb(String language) =>
    jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync())
        as Map<String, dynamic>;

Iterable<String> _messages(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@'));

/// The `{name}` placeholders a message uses.
Set<String> _placeholders(String message) => {
  for (final match in RegExp(r'\{(\w+)\}').allMatches(message)) match[1]!,
};

void main() {
  final english = _arb('en');

  test(
    'English is the main language, the one the others are checked against',
    () {
      expect(AppLocalizations.supportedLocales.first, const Locale('en'));
      expect(File('l10n.yaml').readAsStringSync(), contains('app_en.arb'));
    },
  );

  for (final language in ['it']) {
    group(language, () {
      final translated = _arb(language);

      test('has every message of the English file, and no other', () {
        expect(_messages(translated).toSet(), _messages(english).toSet());
      });

      test('writes the same placeholders as the English message', () {
        for (final key in _messages(english)) {
          expect(
            _placeholders(translated[key] as String),
            _placeholders(english[key] as String),
            reason: key,
          );
        }
      });

      test('has no empty message', () {
        for (final key in _messages(translated)) {
          expect((translated[key] as String).trim(), isNotEmpty, reason: key);
        }
      });
    });
  }

  test('every message of English is described for the translators', () {
    for (final key in _messages(english)) {
      expect(english['@$key'], isNotNull, reason: '$key has no description');
    }
  });

  test('an unsupported language falls back to English', () {
    final resolved = basicLocaleListResolution(const [
      Locale('fr'),
    ], AppLocalizations.supportedLocales);

    expect(resolved, const Locale('en'));
  });

  test('a supported system language is used', () {
    final resolved = basicLocaleListResolution(const [
      Locale('it', 'IT'),
    ], AppLocalizations.supportedLocales);

    expect(resolved, const Locale('it'));
  });
}
