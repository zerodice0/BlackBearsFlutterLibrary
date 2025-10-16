import 'data_model.dart';

class DaumPostcodeCallbackParser {
  static const String urlScheme = 'daumpostcode';
  static const String urlHost = 'result';

  static DataModel? fromUrlScheme(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.scheme != urlScheme || uri.host != urlHost) {
        return null;
      }

      final dataParam = uri.queryParameters['data'];
      if (dataParam == null) return null;

      final decodedJson = Uri.decodeComponent(dataParam);
      return DataModel.fromJson(decodedJson);
    } catch (_) {
      return null;
    }
  }

  static DataModel? fromPostMessage(String message) {
    try {
      return DataModel.fromJson(message);
    } catch (_) {
      return null;
    }
  }

  static DataModel? fromMap(Map<String, dynamic> data) {
    try {
      return DataModel.fromMap(data);
    } catch (_) {
      return null;
    }
  }

  static bool isCallbackUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == urlScheme && uri.host == urlHost;
    } catch (_) {
      return false;
    }
  }
}
