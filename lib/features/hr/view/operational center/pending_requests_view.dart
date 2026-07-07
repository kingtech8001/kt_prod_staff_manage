import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/hr_controller.dart';
import '../../controller/operations_controller.dart';

class PendingRequestsView extends StatefulWidget {
  const PendingRequestsView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<PendingRequestsView> createState() => _PendingRequestsViewState();
}

class _PendingRequestsViewState extends State<PendingRequestsView> {
  final controller = Get.find<OperationsController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetPendingLeaves();
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
                    "Pending Leave Requests",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.pendingLeaves.isEmpty) {
                    return const Center(
                      child: Text(
                        "No pending leave requests",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.pendingLeaves.length,

                    separatorBuilder: (_, __) => const Divider(height: 20),

                    itemBuilder: (context, index) {
                      final leave = controller.pendingLeaves[index];

                      final employee =
                          leave['profiles']?['full_name'] ?? 'Employee';

                      return ListTile(
                        leading: CircleAvatar(child: Text(employee[0])),

                        title: Text(
                          employee,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),

                        subtitle: Text(leave['leave_type'] ?? ''),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            OutlinedButton(
                              onPressed: () {
                                // Reject
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFDC2626),
                                side: const BorderSide(
                                  color: Color(0xFFFCA5A5),
                                  width: 1.2,
                                ),
                                backgroundColor: const Color(0xFFFFFBFB),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                "Reject",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 8),

                            ElevatedButton(
                              onPressed: () {
                                // Approve
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFDCFCE7,
                                ), // Light green
                                foregroundColor: const Color(
                                  0xFF16A34A,
                                ), // Green text
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                "Approve",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 20),

              Obx(() {
                if (controller.isLoadingPendingLeaves.value) {
                  return const CircularProgressIndicator();
                }

                if (!controller.hasMorePendingLeaves.value) {
                  return const Text("No more pending requests");
                }

                return SizedBox(
                  width: 180,

                  child: ElevatedButton(
                    onPressed: controller.loadMorePendingLeaves,

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
