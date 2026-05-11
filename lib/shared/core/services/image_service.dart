import 'dart:io';
import 'package:flutter/foundation.dart';

class ImageService {
  static bool get isSupported =>
      !kIsWeb &&
          (Platform.isAndroid || Platform.isIOS);
}