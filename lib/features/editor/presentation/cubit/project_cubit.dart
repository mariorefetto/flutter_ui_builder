import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/core/usecase/usecase.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/project_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_state.dart';

/// Saves and opens project files and tracks which document is on disk. The
/// edited document itself lives in EditorCubit.
class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit({
    required EditorDocument initialDocument,
    required SaveDocument saveDocument,
    required SaveDocumentAs saveDocumentAs,
    required OpenDocument openDocument,
  }) : _saveDocument = saveDocument,
       _saveDocumentAs = saveDocumentAs,
       _openDocument = openDocument,
       super(ProjectState(savedDocument: initialDocument));

  final SaveDocument _saveDocument;
  final SaveDocumentAs _saveDocumentAs;
  final OpenDocument _openDocument;

  /// Saves [document] to its file, asking for one the first time.
  Future<void> save(EditorDocument document) async {
    final path = state.filePath;
    if (path == null) return saveAs(document);
    final result = await _saveDocument(
      SaveDocumentParams(path: path, document: document),
    );
    if (isClosed) return;
    _markSaved(result.map((_) => path), document);
  }

  Future<void> saveAs(EditorDocument document) async {
    final result = await _saveDocumentAs(document);
    if (isClosed) return;
    // A dismissed dialog is not an error: nothing happens.
    result.fold(
      (failure) => _notify(ProjectFailed(failure)),
      (path) => path == null ? null : _markSaved(Right(path), document),
    );
  }

  Future<void> open() async {
    final result = await _openDocument(const NoParams());
    if (isClosed) return;
    result.fold((failure) => _notify(ProjectFailed(failure)), (opened) {
      if (opened == null) return;
      emit(ProjectState(savedDocument: opened.document, filePath: opened.path));
      _notify(ProjectOpened(opened.document));
    });
  }

  /// Forgets the current file and treats [document] as the saved state.
  void startNew(EditorDocument document) =>
      emit(ProjectState(savedDocument: document));

  void _markSaved(Either<Failure, String> result, EditorDocument document) {
    result.fold((failure) => _notify(ProjectFailed(failure)), (path) {
      emit(ProjectState(savedDocument: document, filePath: path));
      _notify(const ProjectSaved());
    });
  }

  void _notify(ProjectEvent event) {
    emit(state.copyWith(event: event));
    emit(state.copyWith(event: null));
  }
}
