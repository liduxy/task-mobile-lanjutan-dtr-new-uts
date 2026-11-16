import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    // Main route sudah mendaftarkan controller ini; hindari duplikasi ketika
    // halaman Account dibuka dari tab Profile.
    if (!Get.isRegistered<AccountController>()) {
      Get.lazyPut<AccountController>(() => AccountController());
    }
  }
}
