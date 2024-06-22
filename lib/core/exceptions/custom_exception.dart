enum ErrorType {
  network,
  database,
  authentication,
  unknown,
  continuable,
}

class CustomException implements Exception {
  final String messange;
  final ErrorType errorType;
  CustomException(this.messange, {this.errorType = ErrorType.unknown});
  @override
  String toString() {
    return "Error: ${errorType.name} - $messange";
  }
}
