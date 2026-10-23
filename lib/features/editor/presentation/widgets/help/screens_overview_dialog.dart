import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/di/injection.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/project_screen.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/workspace_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/preview_screen.dart';
import 'package:flutter_ui_builder/features/editor/presentation/preview/project_scopes.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/canvas/scaled_box.dart';

const double _thumbnailScale = 0.4;
const double _dialogHeight = 520;

/// Opens the overview of the screens.
Future<void> showScreensOverview(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: context.read<EditorCubit>()),
      BlocProvider.value(value: context.read<WorkspaceCubit>()),
    ],
    child: const ScreensOverviewDialog(),
  ),
);

/// All the screens of the project side by side, drawn small and in the order
/// of the project, so the whole app can be seen at once. A click opens one.
class ScreensOverviewDialog extends StatelessWidget {
  const ScreensOverviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editor = context.read<EditorCubit>();
    final document = editor.state.document;
    final device = context.read<WorkspaceCubit>().state.device;
    final screen = device.size(landscape: false);
    final screens = [
      for (final entry in const ScreenEditor().entriesOf(document))
        if (!entry.component) entry,
    ];
    return AlertDialog(
      title: Text(l10n.overviewTitle),
      content: SizedBox(
        width: double.maxFinite,
        height: _dialogHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: screens.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: AppConstants.spacingMD),
          itemBuilder: (context, index) => _Thumbnail(
            screen: screens[index],
            size: screen,
            first: index == 0,
            open: screens[index].name == document.name,
            onTap: () {
              editor.openScreen(screens[index].name);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.screen,
    required this.size,
    required this.first,
    required this.open,
    required this.onTap,
  });

  final ProjectScreen screen;
  final Size size;
  final bool first;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final document = context.read<EditorCubit>().state.document;
    final previews = sl<PreviewRegistry>();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: open ? colors.primary : colors.outlineVariant,
                width: open
                    ? AppConstants.borderWidthMedium
                    : AppConstants.borderWidthThin,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              child: ScaledBox(
                scale: _thumbnailScale,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: IgnorePointer(
                    child: PreviewScreenScope(
                      size: size,
                      insets: EdgeInsets.zero,
                      child: ProjectScopes(
                        document: document,
                        previews: previews,
                        builder: (context) =>
                            previews.build(context, screen.root),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSM),
          Text(
            first ? context.l10n.overviewStart(screen.name) : screen.name,
            style: context.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
