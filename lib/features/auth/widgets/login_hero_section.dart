import 'dart:ui';
import 'package:flutter/material.dart';

class LoginHeroSection extends StatelessWidget {
  const LoginHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                width: 460,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(height: 16),
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Manage attendance, leave requests, employee activity, HR operations and workforce analytics from a single enterprise platform.',
                      style: TextStyle(color: Colors.black45, fontSize: 16, height: 1.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
