import 'package:flutter_ui_builder/core/error/failures.dart';

/// Exceptions thrown inside the data layer. The repositories convert them to
/// Failure values, so nothing above the data layer sees an exception.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;
}

/// Reading or writing a file failed.
final class FileAccessException extends AppException {
  const FileAccessException([super.message = 'File access failed']);
}

/// A saved document could not be understood.
final class InvalidDocumentException extends AppException {
  const InvalidDocumentException(
    this.reason, [
    super.message = 'Invalid document',
  ]);

  final DocumentFailureReason reason;
}

extension AppExceptionX on AppException {
  Failure toFailure() => switch (this) {
    FileAccessException(:final message) => StorageFailure(
      StorageFailureReason.access,
      message,
    ),
    InvalidDocumentException(:final reason, :final message) => DocumentFailure(
      reason,
      message,
    ),
  };
}
