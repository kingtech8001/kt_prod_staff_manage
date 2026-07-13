import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final _supabase = Supabase.instance.client;

  static const int hrPageSize = 10;

  Future<List<Map<String, dynamic>>> getHrStaff({
    String search = '',
    int page = 0,
    int limit = hrPageSize,
  }) async {
    final start = page * limit;
    final end = start + limit - 1;

    final query = _supabase.from('profiles').select().eq('role', 'HR');

    final response =
        await (search.trim().isEmpty
                ? query
                : query.or(
                    'full_name.ilike.%$search%,employee_code.ilike.%$search%,designation.ilike.%$search%',
                  ))
            .order('full_name')
            .range(start, end);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> searchHrStaff(String search) async {
    if (search.trim().isEmpty) return [];

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'HR')
        .or(
          'full_name.ilike.%$search%,employee_code.ilike.%$search%,designation.ilike.%$search%',
        )
        .limit(8);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getHrById(String hrId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', hrId)
        .maybeSingle();

    return response;
  }

  Future<Map<String, int>> getHrDashboardStats() async {
    final hr = await _supabase
        .from('profiles')
        .select('id, designation')
        .eq('role', 'HR')
        .eq('is_active', true);

    final totalHr = hr.length;

    final managers = hr
        .where(
          (e) => (e['designation'] ?? '').toString().toLowerCase().contains(
            'manager',
          ),
        )
        .length;

    final executives = hr
        .where(
          (e) => (e['designation'] ?? '').toString().toLowerCase().contains(
            'executive',
          ),
        )
        .length;

    final active = hr.length;

    return {
      'totalHr': totalHr,
      'activeHr': active,
      'managers': managers,
      'executives': executives,
    };
  }
}
