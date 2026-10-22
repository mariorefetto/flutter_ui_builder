// Where widgets may and may not be placed. The rules keep the builder from
// producing screens that fail at runtime with errors such as "no Material
// widget found" or "unbounded width".

/// Widgets that give their descendants a Material ancestor.
const Set<String> materialAncestors = {'Scaffold', 'Card'};

/// Parents that give their child unbounded width, which breaks widgets that
/// try to fill the width.
const Set<String> unboundedWidthParents = {'Row', 'Wrap'};

/// Parents that give their child unbounded height, which breaks widgets that
/// try to fill the height or scroll.
const Set<String> unboundedHeightParents = {
  'Column',
  'ListView',
  'SingleChildScrollView',
};

/// Parents in which a scrolling widget has no bounded size to fill.
const Set<String> scrollableBlockers = {
  'Row',
  'Column',
  'Wrap',
  'ListView',
  'GridView',
  'SingleChildScrollView',
};

/// Wrapper to put around a widget dropped straight into one of its forbidden
/// parents, so it can still be inserted: a widget that fills the width or the
/// height gets an Expanded in a Row or Column, as a Flutter developer would.
const Map<String, String> expandInRowOrColumn = {
  'Row': 'Expanded',
  'Column': 'Expanded',
};

/// Same, for widgets that only need an Expanded in a Row.
const Map<String, String> expandInRow = {'Row': 'Expanded'};
