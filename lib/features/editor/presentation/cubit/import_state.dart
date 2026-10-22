import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_state.freezed.dart';

@freezed
abstract class ImportState with _$ImportState {
  const factory ImportState({
    /// The outcome of the last render, when it worked.
    ImportResult? result,

    /// Why the last render or file read failed.
    Failure? failure,

    /// Text read from a file, for the dialog to show. It changes each time a
    /// file is read, even to the same text.
    String? fileText,
    @Default(0) int fileRevision,
  }) = _ImportState;
}
