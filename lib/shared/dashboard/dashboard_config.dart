import 'package:flutter/material.dart';

class DashboardConfig {
  final Widget Function() sidebarBuilder;
  final Widget Function() headerBuilder;
  final Widget Function() bodyBuilder;
  final bool Function() showHeader;

  const DashboardConfig({
    required this.sidebarBuilder,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.showHeader,
  });
}
