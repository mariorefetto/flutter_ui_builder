import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_state.freezed.dart';

@freezed
sealed class CodeState with _$CodeState {
  /// The code of the document, ready to read, copy or export.
  const factory CodeState.ready(List<GeneratedFile> files) = CodeReady;

  /// The code could not be generated.
  const factory CodeState.failed(Failure failure) = CodeFailed;

  const factory CodeState.exporting(List<GeneratedFile> files) = CodeExporting;

  /// Emitted once after a successful export, then followed by [CodeReady].
  const factory CodeState.exported(List<GeneratedFile> files, int count) =
      CodeExported;

  /// Emitted once after a failed export, then followed by [CodeReady].
  const factory CodeState.exportFailed(
    List<GeneratedFile> files,
    Failure failure,
  ) = CodeExportFailed;
}
