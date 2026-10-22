import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/core/widgets/app_select.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';

/// The screen a widget opens when it is pressed: none, back, or one of the
/// project's screens, with a shortcut to open that screen for editing.
class ScreenField extends StatelessWidget {
  const ScreenField({required this.value, required this.onChanged, super.key});

  /// The screen name, [navigateBack], or null for none.
  final String? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = value;
    final screens = context.select(
      (EditorCubit c) => const ScreenEditor().namesOf(c.state.document),
    );
    // A target that no screen has any more is still shown, so it can be seen
    // and changed; the problems panel reports it.
    final known =
        current == null || current == navigateBack || screens.contains(current);
    final canOpen = current != null && current != navigateBack && known;
    return Row(
      children: [
        Expanded(
          child: AppSelect<String>(
            value: current,
            hint: l10n.screenNavigateNone,
            options: [
              AppSelectOption(value: null, label: l10n.screenNavigateNone),
              AppSelectOption(
                value: navigateBack,
                label: l10n.screenNavigateBack,
              ),
              for (final name in screens)
                AppSelectOption(value: name, label: name),
              if (!known) AppSelectOption(value: current, label: current),
            ],
            onChanged: onChanged,
          ),
        ),
        IconButton(
          tooltip: l10n.screenOpenTarget,
          visualDensity: VisualDensity.compact,
          icon: const Icon(AppIcons.goTo),
          onPressed: canOpen
              ? () => context.read<EditorCubit>().openScreen(current)
              : null,
        ),
      ],
    );
  }
}
