import 'package:flutter_ui_builder/core/error/failures.dart';
import 'package:flutter_ui_builder/l10n/generated/app_localizations.dart';

/// The single place that words failures for the user.
String messageFor(AppLocalizations l10n, Failure failure) => switch (failure) {
  TreeFailure(:final reason) => switch (reason) {
    TreeFailureReason.unknownNode => l10n.errorUnknownNode,
    TreeFailureReason.unknownParent => l10n.errorUnknownParent,
    TreeFailureReason.unknownType => l10n.errorUnknownType,
    TreeFailureReason.unknownProp => l10n.errorUnknownProp,
    TreeFailureReason.invalidValue => l10n.errorInvalidValue,
    TreeFailureReason.childNotAllowed => l10n.errorChildNotAllowed,
    TreeFailureReason.parentFull => l10n.errorParentFull,
    TreeFailureReason.parentNotAllowed => l10n.errorParentNotAllowed,
    TreeFailureReason.slotTaken => l10n.errorSlotTaken,
    TreeFailureReason.ancestorRequired => l10n.errorAncestorRequired,
    TreeFailureReason.rootNotAllowed => l10n.errorRootNotAllowed,
    TreeFailureReason.noChildren => l10n.errorNoChildren,
    TreeFailureReason.invalidIndex => l10n.errorInvalidIndex,
    TreeFailureReason.rootProtected => l10n.errorRootProtected,
    TreeFailureReason.cyclicMove => l10n.errorCyclicMove,
    TreeFailureReason.nothingToUndo => l10n.errorNothingToUndo,
    TreeFailureReason.nothingToRedo => l10n.errorNothingToRedo,
  },
  StorageFailure(:final reason) => switch (reason) {
    StorageFailureReason.access => l10n.errorStorageAccess,
    StorageFailureReason.notGenerated => l10n.errorStorageNotGenerated,
  },
  DocumentFailure(:final reason) => switch (reason) {
    DocumentFailureReason.invalidFormat => l10n.errorDocumentInvalidFormat,
    DocumentFailureReason.unsupportedVersion =>
      l10n.errorDocumentUnsupportedVersion,
    DocumentFailureReason.unknownWidget => l10n.errorDocumentUnknownWidget,
    DocumentFailureReason.invalidStructure =>
      l10n.errorDocumentInvalidStructure,
    DocumentFailureReason.emptyName => l10n.errorDocumentEmptyName,
    DocumentFailureReason.duplicateScreenName => l10n.errorScreenDuplicate,
    DocumentFailureReason.lastScreen => l10n.errorScreenLast,
    DocumentFailureReason.unknownScreen => l10n.errorScreenUnknown,
    DocumentFailureReason.codeSyntax => l10n.errorCodeSyntax,
    DocumentFailureReason.codeNoWidget => l10n.errorCodeNoWidget,
  },
  CodeGenerationFailure() => l10n.errorCodeGeneration,
};
