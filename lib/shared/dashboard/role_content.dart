import 'package:flutter/material.dart';

class RoleContent extends StatelessWidget {
  final bool profileOpen;
  final bool activityOpen;

  final Widget profileView;
  final Widget activityView;

  final Widget indexedContent;

  const RoleContent({
    super.key,
    required this.profileOpen,
    required this.activityOpen,
    required this.profileView,
    required this.activityView,
    required this.indexedContent,
  });

  @override
  Widget build(BuildContext context) {
    if (profileOpen) {
      return profileView;
    }

    if (activityOpen) {
      return activityView;
    }

    return indexedContent;
  }
}
