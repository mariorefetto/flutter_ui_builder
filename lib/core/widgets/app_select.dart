import 'package:flutter/material.dart';
import 'package:flutter_ui_builder/core/theme/app_constants.dart';
import 'package:flutter_ui_builder/core/theme/app_icons.dart';
import 'package:flutter_ui_builder/core/theme/theme_extensions.dart';

/// One choice of an [AppSelect]. A null [value] is a valid choice, such as
/// "not set".
class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label, this.icon});

  final T? value;
  final String label;
  final IconData? icon;
}

/// More options than this get a search field above them.
const int _searchableFrom = 8;

const double _menuMaxHeight = 320;
const double _menuMinWidth = 160;
const double _fieldHeight = 32;
const double _iconSize = 16;
const double _menuElevation = 6;

/// A drop-down that matches the rest of the interface: a flat field with a
/// chevron, and a rounded menu with the current choice marked by a check,
/// compact rows and, for long lists, a search field.
class AppSelect<T> extends StatefulWidget {
  const AppSelect({
    required this.options,
    required this.value,
    required this.onChanged,
    this.hint,
    this.borderless = false,
    super.key,
  });

  final List<AppSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;

  /// Shown when [value] matches none of the options.
  final String? hint;

  /// Without the outline, for a field that sits in a toolbar.
  final bool borderless;

  @override
  State<AppSelect<T>> createState() => _AppSelectState<T>();
}

class _AppSelectState<T> extends State<AppSelect<T>> {
  final MenuController _controller = MenuController();

  AppSelectOption<T>? get _current =>
      widget.options.where((o) => o.value == widget.value).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : _menuMinWidth;
        return MenuAnchor(
          controller: _controller,
          style: MenuStyle(
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            elevation: const WidgetStatePropertyAll(_menuElevation),
            backgroundColor: WidgetStatePropertyAll(colors.surface),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                side: BorderSide(color: colors.outlineVariant),
              ),
            ),
          ),
          menuChildren: [
            _MenuPanel<T>(
              options: widget.options,
              value: widget.value,
              width: width < _menuMinWidth ? _menuMinWidth : width,
              onPicked: (value) {
                _controller.close();
                widget.onChanged(value);
              },
            ),
          ],
          builder: (context, controller, _) => _Field(
            label: _current?.label ?? widget.hint ?? '',
            icon: _current?.icon,
            muted: _current == null,
            borderless: widget.borderless,
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        );
      },
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.muted,
    required this.borderless,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool muted;
  final bool borderless;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final radius = BorderRadius.circular(AppConstants.radiusMD);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          height: _fieldHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSM,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: borderless
                ? null
                : Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _iconSize),
                const SizedBox(width: AppConstants.spacingSM),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: muted ? colors.onSurfaceVariant : null,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingXS),
              Icon(
                AppIcons.expand,
                size: _iconSize,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuPanel<T> extends StatefulWidget {
  const _MenuPanel({
    required this.options,
    required this.value,
    required this.width,
    required this.onPicked,
  });

  final List<AppSelectOption<T>> options;
  final T? value;
  final double width;
  final ValueChanged<T?> onPicked;

  @override
  State<_MenuPanel<T>> createState() => _MenuPanelState<T>();
}

class _MenuPanelState<T> extends State<_MenuPanel<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.toLowerCase();
    final shown = widget.options
        .where((o) => o.label.toLowerCase().contains(query))
        .toList();
    final searchable = widget.options.length > _searchableFrom;
    return SizedBox(
      width: widget.width,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: _menuMaxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (searchable)
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingSM),
                child: TextField(
                  autofocus: true,
                  onChanged: (text) => setState(() => _query = text.trim()),
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(AppIcons.search, size: _iconSize),
                  ),
                ),
              ),
            Flexible(
              // A column rather than a lazy list: the menu measures its
              // contents to size itself, which a lazy list cannot answer.
              child: SingleChildScrollView(
                primary: false,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingXS,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final option in shown)
                      _OptionRow<T>(
                        option: option,
                        selected: option.value == widget.value,
                        onTap: () => widget.onPicked(option.value),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow<T> extends StatelessWidget {
  const _OptionRow({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final AppSelectOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected ? colors.primaryContainer : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingSM,
          vertical: AppConstants.spacingSM,
        ),
        child: Row(
          children: [
            SizedBox(
              width: _iconSize,
              child: selected
                  ? Icon(AppIcons.check, size: _iconSize, color: colors.primary)
                  : null,
            ),
            const SizedBox(width: AppConstants.spacingSM),
            if (option.icon != null) ...[
              Icon(option.icon, size: _iconSize),
              const SizedBox(width: AppConstants.spacingSM),
            ],
            Expanded(
              child: Text(
                option.label,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
