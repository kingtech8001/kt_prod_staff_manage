import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'search_controller_base.dart';
import 'search_status_card.dart';

class SearchResults extends StatelessWidget {
  final SearchControllerBase controller;
  final String loadingTitle;
  final String loadingSubtitle;
  final String emptyTitle;
  final String emptySubtitle;
  final Widget Function(BuildContext, Map<String, dynamic>) itemBuilder;

  const SearchResults({
    super.key,
    required this.controller,
    required this.loadingTitle,
    required this.loadingSubtitle,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSearching.value) {
        return SearchStatusCard(
          isLoading: true,
          title: loadingTitle,
          subtitle: loadingSubtitle,
        );
      }

      if (controller.searchResults.isEmpty) {
        return SearchStatusCard(
          isLoading: false,
          title: emptyTitle,
          subtitle: emptySubtitle,
        );
      }

      return Container(
        constraints: const BoxConstraints(maxHeight: 340),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: controller.searchResults.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, controller.searchResults[index]);
          },
        ),
      );
    });
  }
}
