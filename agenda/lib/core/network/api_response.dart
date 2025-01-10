class ApiResponse<T> {
  T? data;
  String? error;

  ApiResponse({this.data, this.error});

  bool get isSuccess => error == null;
}