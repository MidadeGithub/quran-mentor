class BaseResponse<Type> {
  int? statusCode;
  String? message;
  Type? data;
  int? currentPage;
  int? lastPage;
  int? unReadTotal;

  BaseResponse({
    this.statusCode,
    this.message,
    this.data,
    this.currentPage,
    this.lastPage,
    this.unReadTotal,
  });
}
