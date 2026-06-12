import 'package:get/get.dart';

class EmployeeDirectoryController extends GetxController {
  /// Selected department filter
  final selectedDepartment = 'All Staff'.obs;

  /// Search text
  final searchQuery = ''.obs;

  /// Dummy employee list (later replace with Supabase)
  final employees = [
    {'name': 'Alex Rivera', 'role': 'Senior Product Designer', 'department': 'Design', 'status': 'Present'},
    {'name': 'Bethany Chen', 'role': 'Software Engineer', 'department': 'Engineering', 'status': 'Late'},
    {'name': 'Carlos Mendez', 'role': 'HR Manager', 'department': 'People', 'status': 'Present'},
    {'name': 'Diana Prince', 'role': 'Marketing Lead', 'department': 'Marketing', 'status': 'Leave'},
    {'name': 'Ethan Hunt', 'role': 'Security Analyst', 'department': 'Operations', 'status': 'Present'},
  ].obs;

  void selectDepartment(String department) {
    selectedDepartment.value = department;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<Map<String, dynamic>> get filteredEmployees {
    return employees.where((employee) {
      final matchesDepartment = selectedDepartment.value == 'All Staff' || employee['department'] == selectedDepartment.value;

      final matchesSearch =
          employee['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          employee['role'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesDepartment && matchesSearch;
    }).toList();
  }
}
