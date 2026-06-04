import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/controller/performance_controller.dart';

final controller = Get.put(PerformanceController());

class PerformanceSidebar extends StatelessWidget {
  const PerformanceSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CurrentRatingCard(),
          const SizedBox(height: 20),
          RecentReviewsCard(),
          const SizedBox(height: 20),
          const AchievementCard(),
        ],
      ),
    );
  }
}

class CurrentRatingCard extends StatelessWidget {
  const CurrentRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: .infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Obx(() {
        double rating = 0;

        if (controller.reviews.isNotEmpty) {
          rating =
              controller.reviews
                  .map((e) => (e['rating'] as num).toDouble())
                  .reduce((a, b) => a + b) /
              controller.reviews.length;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Rating',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating.floor() ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF59E0B),
                  size: 28,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '${rating.toStringAsFixed(1)} / 5',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(100),
              ),
              child: FractionallySizedBox(
                widthFactor: rating / 5,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF64748B),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Top 10% Performer',
              style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
          ],
        );
      }),
    );
  }
}

class RecentReviewsCard extends StatelessWidget {
  const RecentReviewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              if (controller.reviews.isEmpty) {
                return const Text(
                  'No reviews available',
                  style: TextStyle(color: Color(0xFF64748B)),
                );
              }

              return ListView.builder(
                itemCount: controller.reviews.length,
                itemBuilder: (context, index) {
                  final review = controller.reviews[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,

                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.thumb_up, color: Colors.green, size: 18),
                    ),

                    title: Text(review['review'] ?? ''),

                    subtitle: Text(review['review_date']?.toString() ?? ''),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  const AchievementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Achievements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              if (controller.achievements.isEmpty) {
                return const Text(
                  'No achievements yet',
                  style: TextStyle(color: Color(0xFF64748B)),
                );
              }

              return ListView.builder(
                itemCount: controller.achievements.length,
                itemBuilder: (context, index) {
                  final item = controller.achievements[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),

                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.emoji_events, color: Color(0xFFF59E0B), size: 18),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                item['awarded_at']?.toString().split(' ')[0] ?? '',
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
