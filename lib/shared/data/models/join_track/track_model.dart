class ListTracksModel {
  String? id;
  String? name;
  String? slug;
  String? description;
  List<dynamic>? users;
  String? createdAt;
  String? updatedAt;
  int? v;

  ListTracksModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.users,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  ListTracksModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    users = json['users'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'users': users,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
