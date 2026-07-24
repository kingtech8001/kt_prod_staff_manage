import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/utils/date_formatter.dart';
import '../controller/activity_paging_controller.dart';

class EmployeeActivityListView extends StatelessWidget {
  const EmployeeActivityListView({
    super.key,
    required this.role,
    required this.onBack,
  });

  final String role;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivityPagingController>(
      tag: role.toLowerCase(),
    );

    return Container(
      color: const Color(0xFFF5F7FA),

      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Container(
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),

          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    role == "Employee"
                        ? "Employee Activities"
                        : "HR Activities",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: PagingListener(
                  controller: controller.pagingController,
                  builder: (context, state, fetchNextPage) {
                    return PagedListView<int, Map<String, dynamic>>.separated(
                      state: state,
                      fetchNextPage: fetchNextPage,

                      separatorBuilder: (_, __) => const Divider(height: 16),

                      builderDelegate:
                          PagedChildBuilderDelegate<Map<String, dynamic>>(
                            animateTransitions: true,

                            itemBuilder: (context, item, index) {
                              return EmployeeActivityTile(activity: item);
                            },

                            firstPageProgressIndicatorBuilder: (_) =>
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),

                            newPageProgressIndicatorBuilder: (_) =>
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),

                            firstPageErrorIndicatorBuilder: (_) => const Center(
                              child: Text("Something went wrong"),
                            ),

                            noItemsFoundIndicatorBuilder: (_) => const Center(
                              child: Text("No activities found"),
                            ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeActivityTile extends StatelessWidget {
  const EmployeeActivityTile({super.key, required this.activity});

  final Map<String, dynamic> activity;

  @override
  Widget build(BuildContext context) {
    final employee = activity['employee'] as Map<String, dynamic>?;

    final fullName = employee?['full_name']?.toString() ?? 'Unknown';

    final title = activity['title']?.toString() ?? '';

    final activityTime = activity['activity_time']?.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFE9EDF5),
          child: Text(
            fullName.isNotEmpty ? fullName.substring(0, 1).toUpperCase() : "?",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1633),
            ),
          ),
        ),

        title: Text(
          fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(title, style: const TextStyle(color: Color(0xFF64748B))),
        ),

        trailing: Text(
          DateFormatter.formatDateTime(activityTime),
          style: const TextStyle(color: Color(0xFF64748B)),
        ),
      ),
    );
  }
}
