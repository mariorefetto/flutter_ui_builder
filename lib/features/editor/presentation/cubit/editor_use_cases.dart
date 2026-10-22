import 'package:flutter_ui_builder/features/editor/domain/importing/document_reconciler.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/drop_planner.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/screen_editor.dart';
import 'package:flutter_ui_builder/features/editor/domain/services/tree_editor.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/edit_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/history_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/import_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/plan_drop.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/project_usecases.dart';
import 'package:flutter_ui_builder/features/editor/domain/usecases/screen_usecases.dart';

/// Every use case the editor cubit works with, so the cubit takes one
/// dependency instead of a dozen.
class EditorUseCases {
  const EditorUseCases({
    required this.addNode,
    required this.moveNode,
    required this.removeNode,
    required this.updateNodeProp,
    required this.renameDocument,
    required this.undoEdit,
    required this.redoEdit,
    required this.planDrop,
    required this.duplicateNode,
    required this.pasteNode,
    required this.wrapNode,
    required this.unwrapNode,
    required this.applyImport,
    required this.relabelNode,
    required this.addScreen,
    required this.openScreen,
    required this.renameScreen,
    required this.deleteScreen,
    required this.duplicateScreen,
    required this.makeHomeScreen,
  });

  /// Builds the use cases over one tree editor and one drop planner.
  factory EditorUseCases.from({
    required TreeEditor editor,
    required DropPlanner planner,
  }) => EditorUseCases(
    addNode: AddNode(editor),
    moveNode: MoveNode(editor),
    removeNode: RemoveNode(editor),
    updateNodeProp: UpdateNodeProp(editor),
    renameDocument: const RenameDocument(),
    undoEdit: const UndoEdit(),
    redoEdit: const RedoEdit(),
    planDrop: PlanDrop(planner),
    duplicateNode: DuplicateNode(editor),
    pasteNode: PasteNode(editor),
    wrapNode: WrapNode(editor),
    unwrapNode: UnwrapNode(editor),
    applyImport: const ApplyImport(DocumentReconciler()),
    relabelNode: RelabelNode(editor),
    addScreen: const AddScreen(ScreenEditor()),
    openScreen: const OpenScreen(ScreenEditor()),
    renameScreen: const RenameScreen(ScreenEditor()),
    deleteScreen: const DeleteScreen(ScreenEditor()),
    duplicateScreen: const DuplicateScreen(ScreenEditor()),
    makeHomeScreen: const MakeHomeScreen(ScreenEditor()),
  );

  final AddNode addNode;
  final MoveNode moveNode;
  final RemoveNode removeNode;
  final UpdateNodeProp updateNodeProp;
  final RenameDocument renameDocument;
  final UndoEdit undoEdit;
  final RedoEdit redoEdit;
  final PlanDrop planDrop;
  final DuplicateNode duplicateNode;
  final PasteNode pasteNode;
  final WrapNode wrapNode;
  final UnwrapNode unwrapNode;
  final ApplyImport applyImport;
  final RelabelNode relabelNode;
  final AddScreen addScreen;
  final OpenScreen openScreen;
  final RenameScreen renameScreen;
  final DeleteScreen deleteScreen;
  final DuplicateScreen duplicateScreen;
  final MakeHomeScreen makeHomeScreen;
}
