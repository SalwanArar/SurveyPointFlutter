class DeviceAlreadyAttachedException implements Exception {
  const DeviceAlreadyAttachedException(this.msg);

  final String msg;
}

class TooManyAttemptsException implements Exception {
  const TooManyAttemptsException(this.msg);
  final String msg;
}

class UnAuthenticatedException implements Exception {
  const UnAuthenticatedException(this.msg);
  final String msg;
}
