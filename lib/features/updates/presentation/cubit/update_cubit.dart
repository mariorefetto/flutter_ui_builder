import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/app_info.dart';
import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/features/updates/domain/entities/app_version.dart';
import 'package:flutter_ui_builder/features/updates/domain/usecases/update_usecases.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_state.dart';

/// Looks for a newer version of the app. A quiet check, made at startup,
/// speaks only when it finds one; a check the person asks for always answers.
class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit({
    required CheckForUpdate checkForUpdate,
    required OpenLink openLink,
    AppVersion? current,
  }) : _check = checkForUpdate,
       _open = openLink,
       _current = current ?? AppVersion.tryParse(appVersion)!,
       super(const UpdateState.idle());

  final CheckForUpdate _check;
  final OpenLink _open;
  final AppVersion _current;
  bool _busy = false;

  Future<void> check({bool quiet = false}) async {
    if (_busy) return;
    _busy = true;
    if (!quiet) emit(const UpdateState.checking());
    final result = await _check(_current);
    _busy = false;
    if (isClosed) return;
    result.fold(
      // A quiet check that finds nothing, or fails, has nothing to say.
      (failure) {
        if (!quiet) emit(UpdateState.failed(failure));
      },
      (release) {
        if (release != null) {
          emit(UpdateState.available(release));
        } else if (!quiet) {
          emit(const UpdateState.upToDate());
        }
      },
    );
  }

  /// Opens the page of the newer version, when there is one.
  Future<Either<Failure, Unit>> openRelease() async {
    final current = state;
    if (current is! UpdateAvailable) return const Right(unit);
    return _open(current.release.url);
  }
}
