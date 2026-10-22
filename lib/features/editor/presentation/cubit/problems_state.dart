import 'package:flutter_ui_builder/features/editor/domain/entities/problem.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'problems_state.freezed.dart';

@freezed
abstract class ProblemsState with _$ProblemsState {
  const factory ProblemsState({@Default(<Problem>[]) List<Problem> problems}) =
      _ProblemsState;

  // Freezed needs this private constructor to allow members and getters.
  const ProblemsState._();

  int get warnings =>
      problems.where((p) => p.severity == ProblemSeverity.warning).length;

  int get infos =>
      problems.where((p) => p.severity == ProblemSeverity.info).length;
}
