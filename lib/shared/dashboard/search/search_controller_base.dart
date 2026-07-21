import 'package:get/get.dart';

abstract class SearchControllerBase extends GetxController {
  RxString get searchQuery;

  RxBool get isSearching;

  RxList<Map<String, dynamic>> get searchResults;

  Future<void> updateSearch(String value);
}
