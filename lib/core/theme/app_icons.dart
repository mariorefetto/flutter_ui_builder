import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The icons of the editor's own interface, one set (Lucide) for all of it.
/// The icons a user puts in a design are the Material ones and live elsewhere.
abstract final class AppIcons {
  static const IconData search = LucideIcons.search;
  static const IconData clear = LucideIcons.x;
  static const IconData close = LucideIcons.x;
  static const IconData check = LucideIcons.check;
  static const IconData copy = LucideIcons.copy;
  static const IconData code = LucideIcons.code;
  static const IconData undo = LucideIcons.undo2;
  static const IconData redo = LucideIcons.redo2;
  static const IconData zoomIn = LucideIcons.zoomIn;
  static const IconData zoomOut = LucideIcons.zoomOut;
  static const IconData reset = LucideIcons.rotateCcw;
  static const IconData rotate = LucideIcons.rotateCw;
  static const IconData device = LucideIcons.smartphone;
  static const IconData safeArea = LucideIcons.scan;
  static const IconData run = LucideIcons.play;
  static const IconData theme = LucideIcons.palette;
  static const IconData newFile = LucideIcons.filePlus;
  static const IconData open = LucideIcons.folderOpen;
  static const IconData openFile = LucideIcons.fileCode;
  static const IconData save = LucideIcons.save;
  static const IconData export = LucideIcons.fileDown;
  static const IconData importCode = LucideIcons.fileInput;
  static const IconData delete = LucideIcons.trash2;
  static const IconData drag = LucideIcons.gripVertical;
  static const IconData expand = LucideIcons.chevronDown;
  static const IconData collapsed = LucideIcons.chevronRight;
  static const IconData warning = LucideIcons.triangleAlert;
  static const IconData error = LucideIcons.circleAlert;
  static const IconData info = LucideIcons.info;
  static const IconData success = LucideIcons.circleCheck;
  static const IconData sortAlpha = LucideIcons.arrowDownAZ;
  static const IconData list = LucideIcons.list;
  static const IconData outline = LucideIcons.listTree;
  static const IconData tools = LucideIcons.wrench;
  static const IconData design = LucideIcons.layoutTemplate;
  static const IconData screens = LucideIcons.layers;
  static const IconData add = LucideIcons.plus;
}
