class ApiResponse {
  int responseCode;
  dynamic body;

  ApiResponse({
    required this.responseCode,
    this.body
  });
}
