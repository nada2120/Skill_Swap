class TopUser {
  final int id;
  final String image;
  final String name;
  final String track;
  final String hours;

  TopUser({
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.hours,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      track: json['track'],
      hours: json['hours'],
    );
  }
}