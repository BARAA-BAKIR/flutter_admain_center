class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return PaginatedResponse(
      data: (json['data'] as List).map(fromJsonT).toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}
