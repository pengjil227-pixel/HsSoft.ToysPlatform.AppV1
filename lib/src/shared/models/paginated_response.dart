class PaginatedResponse<T> {
  PaginatedResponse({
    required this.pageNo,
    required this.pageSize,
    required this.totalPage,
    required this.totalRows,
    required this.rows,
  });

  final int pageNo;
  final int pageSize;
  final int totalPage;
  final int totalRows;
  final List<T> rows;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse<T>(
      pageNo: json['pageNo'],
      pageSize: json['pageSize'],
      totalPage: json['totalPage'],
      totalRows: json['totalRows'],
      rows: (json['rows'] as List<dynamic>).map((e) => fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJson) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNo'] = pageNo;
    data['pageSize'] = pageSize;
    data['totalPage'] = totalPage;
    data['totalRows'] = totalRows;
    data['rows'] = rows.map((e) => toJson(e)).toList();
    return data;
  }

  bool get hasNextPage => pageNo < totalPage;
  bool get hasPrevPage => pageNo > 1;
  bool get isEmpty => rows.isEmpty;
}
