import 'dart:async';

import 'package:get/get.dart';

import '../repository/admin_repository.dart';

class HrDirectoryController extends GetxController {
  final repository = AdminRepository();

  static const hrPageSize = 10;

  final hrStaff = <Map<String, dynamic>>[].obs;

  final hrPage = 0.obs;
  final hasMoreHr = true.obs;
  final isLoadingHr = false.obs;

  final totalHr = 0.obs;
  final activeHr = 0.obs;
  final managers = 0.obs;
  final executives = 0.obs;

  final searchQuery = ''.obs;

  final searchResults = <Map<String, dynamic>>[].obs;
  final isSearching = false.obs;

  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();

    loadHr(refresh: true);

    loadDashboardStats();
  }

  Future<void> loadHr({bool refresh = false}) async {
    if (isLoadingHr.value) return;

    isLoadingHr.value = true;

    try {
      if (refresh) {
        hrPage.value = 0;
        hasMoreHr.value = true;
        hrStaff.clear();
      }

      if (!hasMoreHr.value) return;

      final result = await repository.getHrStaff(
        search: searchQuery.value,
        page: hrPage.value,
        limit: hrPageSize,
      );

      hrStaff.addAll(result);

      if (result.length < hrPageSize) {
        hasMoreHr.value = false;
      } else {
        hrPage.value++;
      }
    } finally {
      isLoadingHr.value = false;
    }
  }

  Future<void> loadMoreHr() async {
    await loadHr();
  }

  Future<void> resetHr() async {
    await loadHr(refresh: true);
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
        final result = await repository.searchHrStaff(value);

        searchResults.assignAll(result);
      } catch (_) {
        searchResults.clear();
      } finally {
        isSearching.value = false;
      }
    });
  }

  Future<void> loadDashboardStats() async {
    final stats = await repository.getHrDashboardStats();

    totalHr.value = stats['totalHr']!;
    activeHr.value = stats['activeHr']!;
    managers.value = stats['managers']!;
    executives.value = stats['executives']!;
  }
}
