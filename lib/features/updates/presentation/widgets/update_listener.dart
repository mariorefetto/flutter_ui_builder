import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/app_info.dart';
import 'package:flutter_ui_builder/core/error/failure_messages.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_cubit.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_state.dart';
import 'package:flutter_ui_builder/features/updates/presentation/widgets/update_notice.dart';

/// Answers a check the person asked for, in a message: a newer version, none,
/// or a failure. A quiet check at startup shows only the notice in the status
/// bar, so it never interrupts.
class UpdateListener extends BlocListener<UpdateCubit, UpdateState> {
  UpdateListener({super.key})
    : super(
        // Only what follows a check that was asked for, which is announced by
        // the checking state.
        listenWhen: (previous, current) =>
            previous is UpdateChecking && current is! UpdateChecking,
        listener: _answer,
      );

  static void _answer(BuildContext context, UpdateState state) {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    switch (state) {
      case UpdateAvailable(:final release):
        messenger.showSnackBar(
          SnackBar(
            // With an action, a message stays until it is closed; this one
            // goes away, and the status bar keeps the notice.
            persist: false,
            content: Text(
              l10n.updateAvailableMessage(release.version.toString()),
            ),
            action: SnackBarAction(
              label: l10n.updateDownload,
              onPressed: () => openReleasePage(context),
            ),
          ),
        );
      case UpdateUpToDate():
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.updateUpToDate(appVersion))),
        );
      case UpdateFailed(:final failure):
        messenger.showSnackBar(
          SnackBar(content: Text(messageFor(l10n, failure))),
        );
      case UpdateIdle() || UpdateChecking():
        break;
    }
  }
}
