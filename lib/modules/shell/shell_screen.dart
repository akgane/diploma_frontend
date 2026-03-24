import 'package:flutter/material.dart';
import 'package:food_tracker/modules/home/screens/home_screen.dart';
import 'package:food_tracker/modules/inventory/screens/inventory_screen.dart';
import 'package:food_tracker/modules/recipes/screens/recipes_screen.dart';
import 'package:food_tracker/modules/scanner/screens/scanner_screen.dart';
import 'package:food_tracker/modules/settings/screens/settings_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    InventoryScreen(),
    RecipesScreen(),
    SettingsScreen()
  ];

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'scanner_fab',
        onPressed: _openScanner,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home', index: 0, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            _NavItem(icon: Icons.kitchen_outlined, selectedIcon: Icons.kitchen, label: 'Inventory', index: 1, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            const SizedBox(width: 48), // for FAB
            _NavItem(icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: 'Recipes', index: 2, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            _NavItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings', index: 3, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int currentIndex;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}