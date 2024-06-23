enum ErrorType {
  network,
  database,
  authentication,
  unknown,
  continuable,
}

class CustomException implements Exception {
  final String message;
  final String? title;

  final ErrorType errorType;
  CustomException(this.message,
      {this.errorType = ErrorType.unknown, this.title});
  @override
  String toString() {
    return "Error: ${errorType.name} - title: $title, messange: $message";
  }
}
