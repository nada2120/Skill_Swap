import 'package:equatable/equatable.dart';

class StoreImage extends Equatable {
  final String? secureUrl;
  final String? publicId;

  const StoreImage({
    this.secureUrl,
    this.publicId,
  });

  @override
  List<Object?> get props => [
        secureUrl,
        publicId,
      ];

  factory StoreImage.fromJson(Map<String, dynamic> json) {
    return StoreImage(
      secureUrl: json['secure_url'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }

  factory StoreImage.empty() {
    return StoreImage(secureUrl: "", publicId: "");
  }

  Map<String, dynamic> toJson() {
    return {
      'secureUrl': secureUrl,
      'publicId': publicId,
    };
  }
}
