import 'dart:io';

import 'package:flutter_ui_builder/core/error/exceptions.dart';

abstract interface class ExternalLinkDataSource {
  /// Opens [url] in the default browser. Throws [LaunchException] when the
  /// system does not.
  Future<void> open(Uri url);
}

class SystemLinkDataSource implements ExternalLinkDataSource {
  const SystemLinkDataSource();

  @override
  Future<void> open(Uri url) async {
    final (command, arguments) = _commandFor(url.toString());
    try {
      final result = await Process.run(command, arguments);
      if (result.exitCode != 0) {
        throw LaunchException('$command ended with ${result.exitCode}');
      }
    } on ProcessException catch (e) {
      throw LaunchException(e.message);
    }
  }

  (String, List<String>) _commandFor(String url) {
    if (Platform.isMacOS) {
      return ('open', [url]);
    }
    if (Platform.isWindows) {
      return ('rundll32', ['url.dll,FileProtocolHandler', url]);
    }
    return ('xdg-open', [url]);
  }
}
