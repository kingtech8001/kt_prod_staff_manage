import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/view_all_button.dart';
import '../../controller/hr_controller.dart';
import '../../controller/operations_controller.dart';

class LiveActivityCard extends StatelessWidget {
  const LiveActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OperationsController>();
    final hrController = Get.find<HrController>();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Activity Feed',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              if (controller.liveActivities.isEmpty) {
                return const Center(
                  child: Text(
                    'No live activities',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                );
              }

              final activities = controller.liveActivities.take(5).toList();

              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (_, index) {
                  final activity = activities[index];
                  final profile = activity['profiles'];

                  return ActivityItem(
                    icon: _getIcon(activity['activity_type']),
                    color: _getColor(activity['activity_type']),
                    title:
                        "${profile?['full_name'] ?? 'Employee'} • ${activity['title']}",
                    time: DateFormatter.formatDateTime(
                      activity['activity_time']?.toString(),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 16),

          Align(
            alignment: .centerRight,
            child: ViewAllButton(
              text: "View All Activities",
              onPressed: () async {
                hrController.changeIndex(HrController.liveActivities);

                await controller.resetLiveActivities();
              },
            ),
          ),
        ],
      ),
    );
  }
}

IconData _getIcon(String? type) {
  switch (type) {
    case 'PUNCH_IN':
      return Icons.login;

    case 'BREAK_START':
      return Icons.free_breakfast;

    case 'BREAK_END':
      return Icons.play_arrow;

    case 'PUNCH_OUT':
      return Icons.logout;

    case 'ATTENDANCE_UPDATE':
      return Icons.fact_check;

    default:
      return Icons.history;
  }
}

Color _getColor(String? type) {
  switch (type) {
    case 'PUNCH_IN':
      return Colors.green;

    case 'BREAK_START':
      return Colors.orange;

    case 'BREAK_END':
      return Colors.blue;

    case 'PUNCH_OUT':
      return Colors.red;

    case 'ATTENDANCE_UPDATE':
      return Colors.purple;

    default:
      return Colors.grey;
  }
}

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String title;
  final String time;

  const ActivityItem({
    super.key,
    required this.icon,
    this.color,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color ?? const Color(0xFF64748B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(
                  DateFormatter.formatDateTime(time),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveActivitiesView extends StatefulWidget {
  const LiveActivitiesView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<LiveActivitiesView> createState() => _LiveActivitiesViewState();
}

class _LiveActivitiesViewState extends State<LiveActivitiesView> {
  final controller = Get.find<OperationsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetLiveActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Live Activity Feed",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.liveActivities.isEmpty) {
                    return const Center(
                      child: Text(
                        "No live activities",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.liveActivities.length,

                    separatorBuilder: (_, __) => const Divider(height: 16),

                    itemBuilder: (_, index) {
                      final activity = controller.liveActivities[index];

                      final profile = activity['profiles'];

                      return ListTile(
                        leading: Icon(
                          _getIcon(activity['activity_type']),
                          color: _getColor(activity['activity_type']),
                        ),

                        title: Text(
                          "${profile?['full_name'] ?? 'Employee'} • ${activity['title']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            DateFormatter.formatDateTime(
                              activity['activity_time']?.toString(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 20),

              Obx(() {
                if (controller.liveActivities.isEmpty) {
                  return const SizedBox();
                }

                if (controller.isLoadingLiveActivities.value) {
                  return const CircularProgressIndicator();
                }

                if (!controller.hasMoreLiveActivities.value) {
                  return const Text(
                    "No more live activities",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                return SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),

                    onPressed: controller.loadMoreLiveActivities,

                    child: const Text("Load More"),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
