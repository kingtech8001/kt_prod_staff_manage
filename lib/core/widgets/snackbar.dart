import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSnackbar {
  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      maxWidth: 380,
      snackPosition: SnackPosition.TOP,

      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      maxWidth: 380,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFDC2626),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 14,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  static void warning(String title, String message) {
    Get.snackbar(
      title,
      message,
      maxWidth: 380,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFF59E0B),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 14,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
    );
  }

  static void info(String title, String message) {
    Get.snackbar(
      title,
      message,
      maxWidth: 380,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF2563EB),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 14,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }
}
