class DublicateException implements Exception{
  final String cause;

  DublicateException(this.cause);

  @override
  String toString() => 'DublicateException: $cause';
}