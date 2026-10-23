import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/error/failure_messages.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_cubit.dart';
import 'package:flutter_ui_builder/features/updates/presentation/cubit/update_state.dart';

/// A notice in the status bar when a newer version is published. A click opens
/// the page to download it from. It takes no room when there is nothing new.
class UpdateNotice extends StatelessWidget {
  const UpdateNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UpdateCubit>().state;
    if (state is! UpdateAvailable) return const SizedBox.shrink();
    final version = state.release.version.toString();
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.spacingMD),
      child: Tooltip(
        message: context.l10n.updateAvailableTooltip(version),
        child: InkWell(
          onTap: () => openReleasePage(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(AppIcons.update, size: AppConstants.spacingMD),
              Text(' $version'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the download page, and says so when the browser cannot be opened.
Future<void> openReleasePage(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  final result = await context.read<UpdateCubit>().openRelease();
  result.fold(
    (failure) => messenger.showSnackBar(
      SnackBar(content: Text(messageFor(l10n, failure))),
    ),
    (_) {},
  );
}
