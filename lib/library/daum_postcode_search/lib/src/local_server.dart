import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';

class DaumPostcodeLocalServer {
  HttpServer? _server;
  final String _address;
  final int _port;

  DaumPostcodeLocalServer({
    String address = 'localhost',
    int port = 8080,
  })  : _address = address,
        _port = port;

  Future<void> start() async {
    if (_server != null) return;

    _server = await HttpServer.bind(_address, _port);
    _server!.listen(_handleRequest);
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final uri = request.uri;

    try {
      String assetPath = uri.path;
      if (assetPath.startsWith('/')) {
        assetPath = assetPath.substring(1);
      }

      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      final contentType = _getContentType(assetPath);
      request.response.headers.contentType = contentType;

      request.response.add(bytes);
      await request.response.close();
    } catch (e) {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found: ${uri.path}');
      await request.response.close();
    }
  }

  ContentType _getContentType(String path) {
    if (path.endsWith('.html')) {
      return ContentType('text', 'html', charset: 'utf-8');
    } else if (path.endsWith('.js')) {
      return ContentType('application', 'javascript', charset: 'utf-8');
    } else if (path.endsWith('.css')) {
      return ContentType('text', 'css', charset: 'utf-8');
    } else if (path.endsWith('.json')) {
      return ContentType('application', 'json', charset: 'utf-8');
    } else if (path.endsWith('.png')) {
      return ContentType('image', 'png');
    } else if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
      return ContentType('image', 'jpeg');
    }
    return ContentType('application', 'octet-stream');
  }

  Future<void> stop() async {
    await _server?.close();
    _server = null;
  }

  String get url => 'http://$_address:$_port';

  bool get isRunning => _server != null;
}
