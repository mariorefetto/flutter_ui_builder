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

/// A request to another computer failed or was answered with nonsense.
final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network request failed']);
}

/// The browser could not be opened.
final class LaunchException extends AppException {
  const LaunchException([super.message = 'Could not open the link']);
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
    NetworkException(:final message) => NetworkFailure(message),
    LaunchException(:final message) => LaunchFailure(message),
    InvalidDocumentException(:final reason, :final message) => DocumentFailure(
      reason,
      message,
    ),
  };
}
