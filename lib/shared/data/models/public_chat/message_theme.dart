class MessageTheme {
  final String id;
  final String title;
  final String value;
  final String image;

  const MessageTheme({
    required this.id,
    required this.title,
    required this.value,
    required this.image,
  });

  factory MessageTheme.fromJson(Map<String, dynamic> json) {
    return MessageTheme(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
