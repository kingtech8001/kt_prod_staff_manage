import 'sidebar_item.dart';

class SidebarConfig {
  final double width;
  final int Function() selectedIndex;
  final void Function(int index) onItemSelected;
  final List<SidebarItem> items;

  const SidebarConfig({
    required this.width,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
  });
}
