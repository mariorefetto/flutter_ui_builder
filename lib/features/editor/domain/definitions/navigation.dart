import 'package:flutter_ui_builder/features/editor/domain/services/identifier_names.dart';

/// The property that makes a widget open another screen when it is pressed.
const String navigateToProp = 'navigateTo';

/// Value of [navigateToProp] that goes back to the previous screen.
const String navigateBack = ':back';

const String screenClassSuffix = 'View';
const String screenFileSuffix = '_view.g.dart';

/// The class the code of the screen called [name] declares.
String screenClassName(String name) => '${pascalCase(name)}$screenClassSuffix';

/// The file the code of the screen called [name] is written to.
String screenFileName(String name) => '${snakeCase(name)}$screenFileSuffix';

/// The file that lists the routes of a project that opens screens by name.
const String routesFileName = 'app_routes.g.dart';

/// The route of the screen called [name]: `/settings`.
String routeName(String name) => '/${snakeCase(name)}';

/// The constant that holds the route of the screen called [name].
String routeIdentifier(String name) => 'route${pascalCase(name)}';

/// The callback a widget runs when pressed: it pushes the screen [target], or
/// goes back for [navigateBack]. Null when there is nowhere to go.
String? navigationCallback(String? target) {
  if (target == null || target.isEmpty) return null;
  if (target == navigateBack) return '() => Navigator.pop(context)';
  return '() => Navigator.push(context, MaterialPageRoute<void>('
      'builder: (_) => const ${screenClassName(target)}()))';
}

/// The property of a Component node that names the component it shows.
const String componentProp = 'component';

const String componentClassSuffix = 'Widget';
const String componentFileSuffix = '_widget.g.dart';

/// The class the code of the component called [name] declares.
String componentClassName(String name) =>
    '${pascalCase(name)}$componentClassSuffix';

/// The file the code of the component called [name] is written to.
String componentFileName(String name) =>
    '${snakeCase(name)}$componentFileSuffix';
