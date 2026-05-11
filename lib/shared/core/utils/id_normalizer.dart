class IdNormalizer {
  /// Convert any API id format to a clean String id
  /// Supports:
  /// - String → "abc123"
  /// - int → "123"
  /// - Map → { "_id": "abc123" } أو { "id": "abc123" }
  /// - Object → يستخدم toString كحل أخير
  static String normalize(dynamic value) {
    if (value == null) {
      throw Exception("ID is null");
    }

    // Already String
    if (value is String) {
      return value;
    }

    // Integer
    if (value is int) {
      return value.toString();
    }

    // Map<String, dynamic>
    if (value is Map<String, dynamic>) {
      if (value.containsKey('_id') && value['_id'] != null) {
        return value['_id'].toString();
      }

      if (value.containsKey('id') && value['id'] != null) {
        return value['id'].toString();
      }
    }

    // Fallback
    return value.toString();
  }

  /// Safe version — لا يرمي exception
  static String? tryNormalize(dynamic value) {
    try {
      return normalize(value);
    } catch (_) {
      return null;
    }
  }
}
