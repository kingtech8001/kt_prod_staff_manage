import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getCurrentProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final profile = await supabase.from('profiles').select().eq('id', user.id).single();

    return profile;
  }

  bool get isLoggedIn {
    print('CURRENT SESSION => ${supabase.auth.currentSession}');

    return supabase.auth.currentSession != null;
  }
}
