class InvalidRequestException implements Exception {
  final String cause;

  InvalidRequestException(this.cause);

  @override
  String toString() => 'InvalidRequestException: $cause';
}