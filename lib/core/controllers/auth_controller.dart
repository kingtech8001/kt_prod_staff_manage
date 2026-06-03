import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  void setUser(UserModel user) {
    currentUser.value = user;
  }

  void clearUser() {
    currentUser.value = null;
  }

  UserModel? get user => currentUser.value;

  bool get isLoggedIn => currentUser.value != null;
}
