import 'package:get/get.dart';
import '../repository/hr_repository.dart';

class EmployeeDirectoryController extends GetxController {
  final repository = HrRepository();
  final liveActivities = <Map<String, dynamic>>[].obs;
  final employees = <Map<String, dynamic>>[].obs;
  final isLoadingActivities = false.obs;
  final isLoading = false.obs;

  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
    loadLiveActivities();
  }

  Future<void> loadEmployees() async {
    print('Reloading employee...');
    try {
      isLoading.value = true;

      final result = await repository.getEmployees();

      employees.assignAll(result);
      print('Reloading employee...1111');
    } catch (e) {
      print('Error loading employees: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<Map<String, dynamic>> get filteredEmployees {
    if (searchQuery.value.isEmpty) {
      return employees;
    }

    return employees.where((employee) {
      return employee['full_name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          employee['designation'].toString().toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Future<void> loadLiveActivities() async {
    try {
      isLoadingActivities.value = true;

      liveActivities.value = await repository.getLiveActivities();
    } catch (e) {
      print('Error loading live activities: $e');
    } finally {
      isLoadingActivities.value = false;
    }
  }
}
