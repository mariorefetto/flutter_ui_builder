import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_release.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_state.freezed.dart';

@freezed
sealed class UpdateState with _$UpdateState {
  /// Nothing to say: no check yet, or a quiet one that found nothing.
  const factory UpdateState.idle() = UpdateIdle;

  /// A check the person asked for is under way.
  const factory UpdateState.checking() = UpdateChecking;

  /// A newer version is published.
  const factory UpdateState.available(AppRelease release) = UpdateAvailable;

  /// A check the person asked for found nothing newer.
  const factory UpdateState.upToDate() = UpdateUpToDate;

  /// A check the person asked for could not be made.
  const factory UpdateState.failed(Failure failure) = UpdateFailed;
}
