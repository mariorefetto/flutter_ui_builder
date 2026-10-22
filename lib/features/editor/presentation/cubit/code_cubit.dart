import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/generated_file.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/code_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_state.dart';

/// Generates the code of one document snapshot and exports it to a folder.
class CodeCubit extends Cubit<CodeState> {
  CodeCubit({
    required EditorDocument document,
    required GenerateCode generateCode,
    required PickExportDirectory pickDirectory,
    required ExportCode exportCode,
  }) : _document = document,
       _generateCode = generateCode,
       _pickDirectory = pickDirectory,
       _exportCode = exportCode,
       super(const CodeState.ready([])) {
    generate();
  }

  EditorDocument _document;
  final GenerateCode _generateCode;
  final PickExportDirectory _pickDirectory;
  final ExportCode _exportCode;

  /// Regenerates the code for [document]. An export in progress is not
  /// interrupted: it finishes with the code it started with.
  void update(EditorDocument document) {
    _document = document;
    if (state is! CodeExporting) generate();
  }

  void generate() {
    emit(_generateCode(_document).fold(CodeState.failed, CodeState.ready));
  }

  Future<void> export() async {
    final files = _currentFiles;
    if (files.isEmpty) return;
    emit(CodeState.exporting(files));
    final picked = await _pickDirectory(const NoParams());
    if (isClosed) return;
    await picked.fold(
      (failure) async => _finish(CodeState.exportFailed(files, failure), files),
      (directory) => _exportTo(directory, files),
    );
  }

  Future<void> _exportTo(String? directory, List<GeneratedFile> files) async {
    // A null directory means the user dismissed the dialog.
    if (directory == null) return _finish(null, files);
    final result = await _exportCode(
      ExportCodeParams(directory: directory, files: files),
    );
    if (isClosed) return;
    _finish(
      result.fold(
        (failure) => CodeState.exportFailed(files, failure),
        (paths) => CodeState.exported(files, paths.length),
      ),
      files,
    );
  }

  List<GeneratedFile> get _currentFiles => switch (state) {
    CodeReady(:final files) ||
    CodeExporting(:final files) ||
    CodeExported(:final files) ||
    CodeExportFailed(:final files) => files,
    CodeFailed() => const [],
  };

  // Emits the outcome once, then returns to the ready state. A null outcome
  // means the user dismissed the dialog.
  void _finish(CodeState? outcome, List<GeneratedFile> files) {
    if (outcome != null) emit(outcome);
    emit(CodeState.ready(files));
  }
}
