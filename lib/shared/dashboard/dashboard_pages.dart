import 'package:flutter/material.dart';

class DashboardPages {
  final int Function() currentIndex;
  final List<Widget> pages;

  const DashboardPages({required this.currentIndex, required this.pages});
}
