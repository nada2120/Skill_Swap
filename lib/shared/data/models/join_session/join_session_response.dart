class JoinSessionResponse {
  String? message;

  JoinSessionResponse({this.message});

  JoinSessionResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
