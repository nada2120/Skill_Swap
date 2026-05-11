class ActiveTheme {
  final String id;
  final String title;
  final String value;
  final String imageUrl;

  const ActiveTheme({
    required this.id,
    required this.title,
    required this.value,
    required this.imageUrl,
  });

  factory ActiveTheme.fromJson(Map<String, dynamic> json) {
    return ActiveTheme(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      imageUrl: json['img']?['secure_url']?.toString() ?? '',
    );
  }
}
