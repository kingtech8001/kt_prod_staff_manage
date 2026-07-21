import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../employee_management_controller.dart';
import 'search_controller_base.dart';
import 'search_overlay.dart';
import 'search_results.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.loadingTitle,
    required this.loadingSubtitle,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.itemBuilder,
  });

  final SearchControllerBase controller;
  final String hintText;
  final String loadingTitle;
  final String loadingSubtitle;
  final String emptyTitle;
  final String emptySubtitle;
  final Widget Function(BuildContext, Map<String, dynamic>, VoidCallback)
  itemBuilder;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final SearchOverlay searchOverlay;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchOverlay = SearchOverlay();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchOverlay.hide();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final management = Get.find<EmployeeManagementController>();

    return SizedBox(
      width: 320,
      child: CompositedTransformTarget(
        link: searchOverlay.layerLink,
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          onChanged: (value) {
            widget.controller.updateSearch(value);

            if (value.trim().isEmpty) {
              searchOverlay.hide();
              return;
            }

            if (!searchOverlay.isShowing) {
              searchOverlay.show(
                context: context,
                child: SearchResults(
                  controller: widget.controller,
                  loadingTitle: widget.loadingTitle,
                  loadingSubtitle: widget.loadingSubtitle,
                  emptyTitle: widget.emptyTitle,
                  emptySubtitle: widget.emptySubtitle,
                  itemBuilder: (context, item) {
                    return widget.itemBuilder(context, item, () async {
                      searchOverlay.hide();
                      FocusScope.of(context).unfocus();
                      searchController.clear();
                      widget.controller.updateSearch('');
                      await management.openEmployeeProfile(item);
                    });
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
