import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/lint_document.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/problems_state.dart';

/// The problems found in the open document, refreshed as it changes.
class ProblemsCubit extends Cubit<ProblemsState> {
  ProblemsCubit({
    required EditorDocument document,
    required LintDocument lintDocument,
  }) : _lintDocument = lintDocument,
       super(const ProblemsState()) {
    update(document);
  }

  final LintDocument _lintDocument;

  void update(EditorDocument document) => emit(
    ProblemsState(
      problems: _lintDocument(document).fold((_) => const [], (list) => list),
    ),
  );
}
