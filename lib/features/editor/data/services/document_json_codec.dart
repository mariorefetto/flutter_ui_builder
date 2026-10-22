import 'dart:convert';

import 'package:flutter_ui_builder/core/error/exceptions.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/data/models/editor_document_model.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:json_annotation/json_annotation.dart';

const String _indent = '  ';
const String _versionKey = 'schemaVersion';

/// Reads and writes the project file format.
///
/// The output is indented and its keys are sorted, so saving the same project
/// twice gives identical text and git diffs show only real changes.
class DocumentJsonCodec {
  const DocumentJsonCodec();

  String encode(EditorDocument document) {
    final json = EditorDocumentModel.fromEntity(document).toJson();
    return '${const JsonEncoder.withIndent(_indent).convert(_sorted(json))}\n';
  }

  /// Throws InvalidDocumentException when [text] is not a readable project.
  EditorDocument decode(String text) {
    try {
      final json = jsonDecode(text);
      if (json is! Map<String, dynamic>) throw _invalid();
      final version = json[_versionKey];
      if (version is int && version > currentSchemaVersion) {
        throw const InvalidDocumentException(
          DocumentFailureReason.unsupportedVersion,
          'Project saved by a newer version',
        );
      }
      return EditorDocumentModel.fromJson(json).toEntity();
    } on FormatException catch (e) {
      throw _invalid(e.message);
    } on CheckedFromJsonException catch (e) {
      throw _invalid(e.message ?? 'Unexpected value');
    }
  }

  InvalidDocumentException _invalid([String message = 'Not a project']) =>
      InvalidDocumentException(DocumentFailureReason.invalidFormat, message);

  Object? _sorted(Object? value) => switch (value) {
    Map<String, dynamic>() => {
      for (final key in value.keys.toList()..sort()) key: _sorted(value[key]),
    },
    List<dynamic>() => value.map(_sorted).toList(),
    _ => value,
  };
}
