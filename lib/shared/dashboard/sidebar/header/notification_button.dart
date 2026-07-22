import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  late final NotificationOverlay notificationOverlay;

  @override
  void initState() {
    super.initState();
    notificationOverlay = NotificationOverlay();
  }

  @override
  void dispose() {
    notificationOverlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: CompositedTransformTarget(
        link: notificationOverlay.layerLink,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            notificationOverlay.toggle(
              context: context,
              child: const NotificationCard(),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              size: 28,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Notification system is coming soon.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class NotificationOverlay {
  final ValueNotifier<bool> visible = ValueNotifier(false);
  OverlayEntry? _overlayEntry;
  final LayerLink layerLink = LayerLink();
  bool get isShowing => _overlayEntry != null;

  Future<void> hide() async {
    if (_overlayEntry == null) return;

    visible.value = false;

    await Future.delayed(const Duration(milliseconds: 180));

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void show({
    required BuildContext context,
    required Widget child,
    double width = 340,
  }) {
    if (isShowing) return;

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
                offset: const Offset(-292, 56),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, -14 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: ValueListenableBuilder(
                      valueListenable: visible,
                      builder: (_, isVisible, __) {
                        return AnimatedSlide(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          offset: isVisible
                              ? Offset.zero
                              : const Offset(0, -0.08),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            opacity: isVisible ? 1 : 0,
                            child: Material(
                              color: Colors.transparent,
                              child: SizedBox(width: width, child: child),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);

    visible.value = true;
  }

  Future<void> toggle({
    required BuildContext context,
    required Widget child,
    double width = 340,
  }) async {
    if (isShowing) {
      await hide();
    } else {
      show(context: context, child: child, width: width);
    }
  }
}
