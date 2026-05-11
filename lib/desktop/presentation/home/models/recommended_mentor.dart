class RecommendedMentor {
  final int id;
  final String image;
  final String name;
  final double stars;
  final String track;

  RecommendedMentor({
    required this.id,
    required this.image,
    required this.name,
    required this.stars,
    required this.track,
  });

  factory RecommendedMentor.fromJson(Map<String, dynamic> json) {
    return RecommendedMentor(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      stars: json['stars'],
      track: json['track'],
    );
  }
}