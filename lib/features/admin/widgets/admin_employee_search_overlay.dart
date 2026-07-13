import 'package:flutter/material.dart';
import '../controller/hr_directory_controller.dart';
import '../widgets/admin_employee_search_overlay.dart';

class AdminEmployeeSearchOverlay {
  OverlayEntry? _overlayEntry;

  final LayerLink layerLink = LayerLink();

  bool get isShowing => _overlayEntry != null;

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void show({
    required BuildContext context,
    required Widget child,
    double width = 320,
  }) {
    hide();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned.fill(
          child: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: hide,
              ),

              CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 58),
                child: Material(
                  elevation: 14,
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }
}
