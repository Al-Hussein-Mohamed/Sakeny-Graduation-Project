import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Interceptor that logs requests, responses, errors,
/// and now buffers FormData into a single boxed message.
class LoggerInterceptor extends Interceptor {
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final opts = err.requestOptions;
    final requestPath = '${opts.baseUrl}${opts.path}';
    _logger
      ..e('${opts.method} ERROR → $requestPath')
      ..d('Error type: ${err.error}\nMessage: ${err.message}');
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = '${options.baseUrl}${options.path}';
    _logger.i('${options.method} → $path');

    if (options.queryParameters.isNotEmpty) {
      _logger.d('Query Parameters: ${options.queryParameters}');
    }

    final data = options.data;
    if (data != null && data is! FormData) {
      _logger.d('Body: $data');
    }

    if (data is FormData) {
      final buffer = StringBuffer()
        ..writeln('FormData →')
        ..writeln('── Fields ──────────────────────────');
      for (final MapEntry<String, String> field in data.fields) {
        buffer.writeln('  • ${field.key}: ${field.value}');
      }
      buffer.writeln('── Files ───────────────────────────');
      for (final MapEntry<String, MultipartFile> entry in data.files) {
        final file = entry.value;
        buffer.writeln(
          '  • ${entry.key} → ${file.filename} (${file.length} bytes)',
        );
      }
      _logger.d(buffer.toString());
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('STATUS CODE: ${response.statusCode}')
      ..writeln('STATUS MESSAGE: ${response.statusMessage}')
      ..writeln('HEADERS: ${response.headers}');
    final respData = response.data;
    if (respData is Map) {
      buffer.writeln('Response Data Entries:');
      respData.forEach((k, v) => buffer.writeln('  • $k: $v'));
    } else {
      buffer.writeln('Data: $respData');
    }
    _logger.d(buffer.toString());
    handler.next(response);
  }
}
