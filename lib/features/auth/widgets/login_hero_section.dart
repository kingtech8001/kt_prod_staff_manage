import 'package:flutter/material.dart';

class LoginHeroSection extends StatelessWidget {
  const LoginHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
      decoration: const BoxDecoration(color: Color(0xFFF5F7FA)),
      child: Center(
        child: Container(
          width: 460,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.45),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: const Color(0xFF0B1633), borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.work_rounded, color: Colors.white, size: 36),
              ),

              const SizedBox(height: 32),

              const Text(
                'ProWorkforce',
                style: TextStyle(color: Color(0xFF0B1633), fontSize: 42, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Text('Smart Workforce Management Platform', style: TextStyle(color: Color(0xFF64748B), fontSize: 18)),

              const SizedBox(height: 24),

              const Text(
                'Manage attendance, leave requests, employee activity, HR operations and workforce analytics from a single enterprise platform.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 16, height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
