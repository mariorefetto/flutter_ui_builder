import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/media_asset.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/media_editor.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_state.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/project_cubit.dart';

const double _thumbnail = 40;

/// The pictures of the project. A picture is added from a file, clicked to
/// put an Image that shows it where the selection is, and removed; below the
/// list is the text to add to `pubspec.yaml` so the code can load them.
class MediaPanel extends StatelessWidget {
  const MediaPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<EditorCubit, EditorState>(
      buildWhen: (previous, current) =>
          previous.document.assets != current.document.assets,
      builder: (context, state) {
        final document = state.document;
        final snippet = pubspecAssets(document);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingSM),
              child: FilledButton.icon(
                icon: const Icon(AppIcons.add),
                label: Text(l10n.mediaAdd),
                onPressed: () => _add(context),
              ),
            ),
            Expanded(
              child: document.assets.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingMD),
                        child: Text(
                          l10n.mediaEmpty,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        for (final asset in document.assets)
                          _AssetRow(asset: asset),
                      ],
                    ),
            ),
            if (snippet.isNotEmpty) _Snippet(text: snippet),
          ],
        );
      },
    );
  }

  Future<void> _add(BuildContext context) async {
    final project = context.read<ProjectCubit>();
    final editor = context.read<EditorCubit>();
    editor.addAssets(await project.pickImages());
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({required this.asset});

  final MediaAsset asset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final path = asset.sourcePath;
    return Tooltip(
      message: l10n.mediaUseTooltip,
      child: InkWell(
        onTap: () => context.read<EditorCubit>().addToSelection(
          'Image',
          props: {'source': 'asset', 'url': asset.name},
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSM,
            vertical: AppConstants.spacingXS,
          ),
          child: Row(
            children: [
              SizedBox.square(
                dimension: _thumbnail,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusSM),
                  child: path == null
                      ? ColoredBox(color: colors.surfaceContainerHighest)
                      : Image.file(
                          File(path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => ColoredBox(
                            color: colors.surfaceContainerHighest,
                            child: Icon(
                              AppIcons.media,
                              size: AppConstants.spacingMD,
                              color: colors.outline,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSM),
              Expanded(
                child: Text(asset.name, overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                tooltip: l10n.mediaRemove,
                visualDensity: VisualDensity.compact,
                icon: const Icon(AppIcons.delete),
                onPressed: () =>
                    context.read<EditorCubit>().removeAsset(asset.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The pubspec lines, with a button that copies them.
class _Snippet extends StatelessWidget {
  const _Snippet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    return Container(
      color: colors.surfaceContainerHighest,
      padding: const EdgeInsets.all(AppConstants.spacingSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.mediaPubspec,
                  style: context.textTheme.labelSmall,
                ),
              ),
              IconButton(
                tooltip: l10n.mediaCopyPubspec,
                visualDensity: VisualDensity.compact,
                icon: const Icon(AppIcons.copy),
                onPressed: () => Clipboard.setData(ClipboardData(text: text)),
              ),
            ],
          ),
          SelectableText(
            text,
            style: context.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
