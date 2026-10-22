import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/code_edit_state.dart';

/// How long typing must pause before the edited code is checked.
const Duration codeCheckDelay = Duration(milliseconds: 300);

/// Lets the generated code be edited. The text is checked as it is typed, by
/// importing it, and a text that works can be applied to the document.
///
/// The generated code never overwrites text the user has edited: it replaces
/// it only when there are no edits.
class CodeEditCubit extends Cubit<CodeEditState> {
  CodeEditCubit({required ImportCode importCode})
    : _importCode = importCode,
      super(const CodeEditState());

  final ImportCode _importCode;
  Timer? _timer;

  /// The document generated new code. It is shown unless the user is editing.
  void generatedChanged(String generated) {
    if (state.dirty) {
      emit(state.copyWith(generated: generated));
      return;
    }
    emit(
      CodeEditState(
        text: generated,
        generated: generated,
        revision: state.revision + 1,
      ),
    );
  }

  /// The user typed. The text is checked once typing pauses.
  void edit(String text) {
    _timer?.cancel();
    emit(state.copyWith(text: text, result: null, failure: null));
    if (state.dirty) _timer = Timer(codeCheckDelay, checkNow);
  }

  /// Checks the text now and returns what it makes, or null when it fails.
  ImportResult? checkNow() {
    _timer?.cancel();
    return _importCode(state.text).fold(
      (failure) {
        emit(state.copyWith(result: null, failure: failure));
        return null;
      },
      (result) {
        emit(state.copyWith(result: result, failure: null));
        return result;
      },
    );
  }

  /// The edits were applied to the document: the text is now what the
  /// document generates, once it has regenerated.
  void applied() {
    _timer?.cancel();
    emit(state.copyWith(generated: state.text, result: null, failure: null));
  }

  /// Drops the edits and shows the generated code again.
  void revert() {
    _timer?.cancel();
    emit(
      CodeEditState(
        text: state.generated,
        generated: state.generated,
        revision: state.revision + 1,
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
