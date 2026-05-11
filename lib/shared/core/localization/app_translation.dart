import 'package:get/get.dart';

import '../../lang/ar_EG.dart';
import '../../lang/en_US.dart';

class AppTranslation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': en,
    'ar_EG': ar
  };

}