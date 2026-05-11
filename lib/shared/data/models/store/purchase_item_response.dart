class PurchaseItemResponse {
  String? message;

  PurchaseItemResponse({this.message});

  PurchaseItemResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
