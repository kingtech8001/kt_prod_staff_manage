import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _restoreSession();

    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _fetchAndSetUser(session.user.id);
      } else {
        clearUser();
      }
    });
  }

  void _restoreSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      await _fetchAndSetUser(session.user.id);
    }
  }

  Future<void> _fetchAndSetUser(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      setUser(UserModel.fromJson(response));
    } catch (e) {
      clearUser();
    }
  }

  void setUser(UserModel user) {
    currentUser.value = user;
  }

  void clearUser() {
    currentUser.value = null;
  }

  UserModel? get user => currentUser.value;
  bool get isLoggedIn => currentUser.value != null;
}
