import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_edit_state.freezed.dart';

@freezed
abstract class CodeEditState with _$CodeEditState {
  const factory CodeEditState({
    /// What the code editor shows.
    @Default('') String text,

    /// The code the document generates now.
    @Default('') String generated,

    /// What the edited code makes, when it was checked and worked.
    ImportResult? result,

    /// Why the edited code does not work.
    Failure? failure,

    /// Changes when the text is replaced from outside, so the editor knows to
    /// load it. Typing does not change it.
    @Default(0) int revision,
  }) = _CodeEditState;

  // Freezed needs this private constructor to allow members and getters.
  const CodeEditState._();

  /// The text differs from the generated code.
  bool get dirty => text != generated;
}
