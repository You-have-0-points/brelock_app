class NotFoundException implements Exception{
  final String cause;

  NotFoundException(this.cause);

  @override
  String toString() => 'NotFoundException: $cause';
}