import 'package:get/get.dart';

class LoginController extends GetxController {
  final selectedRole = 'Employee'.obs;

  void changeRole(String role) {
    selectedRole.value = role;
  }
}
