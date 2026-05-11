class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int totalUsers;
  final int limit;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalUsers,
    required this.limit,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalUsers: json['totalUsers'],
      limit: json['limit'],
    );
  }
}
