import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/import_state.dart';

/// The import dialog: renders pasted code into a document and reads Dart
/// files. The document is only built here; the dialog hands it on.
class ImportCubit extends Cubit<ImportState> {
  ImportCubit({
    required ImportCode importCode,
    required PickDartSource pickDartSource,
  }) : _importCode = importCode,
       _pickDartSource = pickDartSource,
       super(const ImportState());

  final ImportCode _importCode;
  final PickDartSource _pickDartSource;

  /// Builds a document from [source] and keeps the result or the failure.
  void render(String source) => emit(
    _importCode(source).fold(
      (failure) => state.copyWith(result: null, failure: failure),
      (result) => state.copyWith(result: result, failure: null),
    ),
  );

  /// Asks for a Dart file and renders it.
  Future<void> openFile() async {
    final picked = await _pickDartSource(const NoParams());
    if (isClosed) return;
    picked.fold(
      (failure) => emit(state.copyWith(result: null, failure: failure)),
      (text) {
        // A dismissed dialog is not an error: nothing changes.
        if (text == null) return;
        emit(
          state.copyWith(fileText: text, fileRevision: state.fileRevision + 1),
        );
        render(text);
      },
    );
  }
}
