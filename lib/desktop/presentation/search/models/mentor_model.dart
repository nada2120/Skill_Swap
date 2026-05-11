class MentorModel {
  final int id;
  final String image;
  final String name;
  final String status;
  final double rate;
  final int hours;
  final double price;
  final List<String> skills;
  final String responseTime;
  final String track;

  MentorModel({
    required this.id,
    required this.image,
    required this.name,
    required this.status,
    required this.rate,
    required this.hours,
    required this.price,
    required this.skills,
    required this.responseTime,
    required this.track
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      status: json['status'],
      rate: json['rate'].toDouble(),
      hours: json['hours'],
      price: json['price'].toDouble(),
      skills: List<String>.from(json['skills']),
      responseTime: json['responseTime'],
      track: json['track']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'status': status,
      'rate': rate,
      'hours': hours,
      'price': price,
      'skills': skills,
      'responseTime': responseTime,
    };
  }
}