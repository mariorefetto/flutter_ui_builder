import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_ui_builder/core/error/exceptions.dart';

/// Where the releases of the app are listed.
final Uri releasesUrl = Uri.https(
  'api.github.com',
  '/repos/mariorefetto/flutter_ui_builder/releases',
  {'per_page': '10'},
);

const Duration _timeout = Duration(seconds: 10);
const int _ok = 200;

/// Fetches the text at [url].
typedef HttpGet = Future<String> Function(Uri url);

abstract interface class ReleaseDataSource {
  /// The JSON text with the list of releases.
  /// Throws [NetworkException] when it cannot be read.
  Future<String> fetchReleases();
}

class GithubReleaseDataSource implements ReleaseDataSource {
  const GithubReleaseDataSource({HttpGet get = httpGet}) : _get = get;

  final HttpGet _get;

  @override
  Future<String> fetchReleases() async {
    try {
      return await _get(releasesUrl);
    } on SocketException catch (e) {
      throw NetworkException(e.message);
    } on TimeoutException {
      throw const NetworkException('The request timed out');
    } on HttpException catch (e) {
      throw NetworkException(e.message);
    } on TlsException catch (e) {
      throw NetworkException(e.message);
    }
  }
}

/// Reads [url] over HTTPS, with a limit on how long it may take.
Future<String> httpGet(Uri url) async {
  final client = HttpClient()..connectionTimeout = _timeout;
  try {
    final request = await client.getUrl(url).timeout(_timeout);
    request.headers
      ..set(HttpHeaders.acceptHeader, 'application/vnd.github+json')
      ..set(HttpHeaders.userAgentHeader, 'flutter-ui-builder');
    final response = await request.close().timeout(_timeout);
    if (response.statusCode != _ok) {
      throw HttpException('Answered ${response.statusCode}', uri: url);
    }
    return await response.transform(utf8.decoder).join().timeout(_timeout);
  } finally {
    client.close(force: true);
  }
}
