// ignore: camel_case_types
class Http_Exception implements Exception {
  final String message;

  Http_Exception(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
