import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_builder/core/utils/l10n_extension.dart';
import 'package:flutter_ui_builder/features/editor/domain/definitions/widget_registry.dart';
import 'package:flutter_ui_builder/features/editor/presentation/cubit/editor_cubit.dart';
import 'package:flutter_ui_builder/features/editor/presentation/widgets/shell/node_menu_items.dart';

/// Lets a node on the canvas open the context menu where it was clicked.
class CanvasMenuScope extends InheritedWidget {
  const CanvasMenuScope({required this.open, required super.child, super.key});

  /// Opens the menu at a position given in global coordinates.
  final ValueChanged<Offset> open;

  static CanvasMenuScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CanvasMenuScope>();

  @override
  bool updateShouldNotify(CanvasMenuScope oldWidget) => false;
}

/// The right-click menu of the canvas: add a widget that fits, clipboard,
/// wrap and remove. Its entries are built only when it opens, so they always
/// reflect the current document.
class CanvasContextMenu extends StatefulWidget {
  const CanvasContextMenu({
    required this.registry,
    required this.child,
    super.key,
  });

  final WidgetRegistry registry;
  final Widget child;

  @override
  State<CanvasContextMenu> createState() => _CanvasContextMenuState();
}

class _CanvasContextMenuState extends State<CanvasContextMenu> {
  final MenuController _controller = MenuController();

  void _open(Offset global) {
    final box = context.findRenderObject();
    if (box is! RenderBox) return;
    _controller.open(position: box.globalToLocal(global));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<EditorCubit>();
    return CanvasMenuScope(
      open: _open,
      child: MenuAnchor(
        controller: _controller,
        menuChildren: [
          const SelectedWidgetHeader(),
          const Divider(),
          AddWidgetMenu(
            registry: widget.registry,
            placement: AddPlacement.inside,
          ),
          AddWidgetMenu(
            registry: widget.registry,
            placement: AddPlacement.beside,
          ),
          const Divider(),
          const ClipboardMenuItems(withShortcuts: false),
          const RenameWidgetMenuItem(),
          const Divider(),
          RestructureMenuItems(registry: widget.registry),
          ComponentMenuItems(registry: widget.registry),
          const Divider(),
          MenuItemButton(
            onPressed: cubit.canCut ? cubit.removeSelected : null,
            child: Text(l10n.editorDelete),
          ),
        ],
        child: widget.child,
      ),
    );
  }
}
