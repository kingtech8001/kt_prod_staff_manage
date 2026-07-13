import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/hr_repository.dart';
import 'dart:async';

class EmployeeDirectoryController extends GetxController {
  final repository = HrRepository();
  final liveActivities = <Map<String, dynamic>>[].obs;
  final employees = <Map<String, dynamic>>[].obs;
  static const employeePageSize = 10;

  final employeePage = 0.obs;
  final hasMoreEmployees = true.obs;
  final isLoadingEmployees = false.obs;

  final isLoadingActivities = false.obs;
  final isLoading = false.obs;
  final totalEmployees = 0.obs;
  final presentToday = 0.obs;
  final lateToday = 0.obs;
  final onLeaveToday = 0.obs;
  final searchQuery = ''.obs;
  Timer? _searchDebounce;

  final searchResults = <Map<String, dynamic>>[].obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadEmployees(refresh: true);

    loadLiveActivities();

    loadDashboardStats();
  }

  Future<void> loadEmployees({bool refresh = false}) async {
    if (isLoadingEmployees.value) return;

    isLoadingEmployees.value = true;

    try {
      if (refresh) {
        employeePage.value = 0;
        hasMoreEmployees.value = true;
        employees.clear();
      }

      if (!hasMoreEmployees.value) return;

      final result = await repository.getEmployees(
        search: searchQuery.value,
        page: employeePage.value,
        limit: employeePageSize,
      );

      employees.addAll(result);

      if (result.length < employeePageSize) {
        hasMoreEmployees.value = false;
      } else {
        employeePage.value++;
      }
    } finally {
      isLoadingEmployees.value = false;
    }
  }

  Future<void> updateSearch(String value) async {
    searchQuery.value = value;

    _searchDebounce?.cancel();

    if (value.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;

    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final result = await repository.searchEmployees(value);

        searchResults.assignAll(result);
      } catch (e) {
        searchResults.clear();
      } finally {
        isSearching.value = false;
      }
    });
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

  Future<void> loadDashboardStats() async {
    try {
      final stats = await repository.getDashboardStats();

      totalEmployees.value = stats['totalEmployees']!;
      presentToday.value = stats['presentToday']!;
      lateToday.value = stats['lateToday']!;
      onLeaveToday.value = stats['onLeaveToday']!;
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadMoreEmployees() async {
    await loadEmployees();
  }

  Future<void> resetEmployees() async {
    await loadEmployees(refresh: true);
  }
}
