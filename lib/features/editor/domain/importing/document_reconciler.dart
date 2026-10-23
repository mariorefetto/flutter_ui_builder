import 'package:flutter_ui_builder/features/editor/domain/definitions/navigation.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/editor_document.dart';
import 'package:flutter_ui_builder/features/editor/domain/entities/widget_node.dart';
import 'package:flutter_ui_builder/features/editor/domain/importing/import_result.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/node_queries.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';

/// Folds code that was edited back into the document it came from.
///
/// An imported tree has brand new ids. To keep the selection and the rest of
/// the editor steady, every widget that is still in the same place with the
/// same type keeps the id it had, and only new widgets get new ids.
class DocumentReconciler {
  const DocumentReconciler();

  EditorDocument reconcile(EditorDocument previous, ImportResult imported) {
    final root = imported.document.root;
    final fresh = _highestOf(previous.root, root) + 1;
    const editor = ScreenEditor();
    return previous.copyWith(
      name: _name(previous, imported),
      root: _retargeted(_carryIds(previous.root, root, _Counter(fresh)), {
        navigateToProp: editor.screensOf(previous),
        componentProp: editor.componentsOf(previous),
      }),
    );
  }

  // Code names a screen or component by its class, so `Settings` stands for
  // the screen "settings" when the project has one that writes the same class.
  WidgetNode _retargeted(WidgetNode node, Map<String, List<String>> known) {
    var props = node.props;
    for (final MapEntry(:key, value: names) in known.entries) {
      final target = props[key];
      if (target is! String || target == navigateBack) continue;
      final match = names
          .where((s) => pascalCase(s) == pascalCase(target))
          .firstOrNull;
      if (match != null && match != target) props = {...props, key: match};
    }
    return node.copyWith(
      props: props,
      children: [for (final c in node.children) _retargeted(c, known)],
    );
  }

  // The imported name unless it is the previous one written as a class name,
  // or there was no class at all.
  String _name(EditorDocument previous, ImportResult imported) {
    if (!imported.named) return previous.name;
    return pascalCase(previous.name) == imported.document.name
        ? previous.name
        : imported.document.name;
  }

  int _highestOf(WidgetNode previous, WidgetNode imported) {
    final a = previous.highestSuffix();
    final b = imported.highestSuffix();
    return a > b ? a : b;
  }

  WidgetNode _carryIds(WidgetNode? old, WidgetNode node, _Counter counter) {
    final sameKind = old != null && old.type == node.type;
    final id = sameKind ? old.id : 'node_${counter.next()}';
    return node.copyWith(
      id: id,
      // A widget that stayed where it was keeps the name the user gave it.
      label: sameKind ? old.label : null,
      children: [
        for (var i = 0; i < node.children.length; i++)
          _carryIds(
            sameKind && i < old.children.length ? old.children[i] : null,
            node.children[i],
            counter,
          ),
      ],
    );
  }
}

class _Counter {
  _Counter(this._value);

  int _value;

  int next() => _value++;
}
