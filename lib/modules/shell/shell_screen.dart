import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/l10n/app_localizations.dart';
import 'package:food_tracker/modules/auth/providers/auth_provider.dart';
import 'package:food_tracker/modules/home/screens/home_screen.dart';
import 'package:food_tracker/modules/recipes/screens/recipes_screen.dart';
import 'package:food_tracker/modules/scanner/screens/scanner_screen.dart';
import 'package:food_tracker/modules/settings/screens/settings_screen.dart';
import 'package:food_tracker/modules/shopping_list/screens/shopping_list_screen.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ShoppingListScreen(),
    RecipesScreen(),
    SettingsScreen(),
  ];

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isBusinesss = ref.watch(currentUserProvider).maybeWhen(
      data: (user) => user?.accountType == 'business',
      orElse: () => false,
    );

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
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
            _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: l.navHome, index: 0, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            _NavItem(icon: Icons.shopping_cart_outlined, selectedIcon: Icons.shopping_cart, label: l.navShopping, index: 1, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            const SizedBox(width: 48),
            _NavItem(
              icon: isBusinesss ? Icons.block_outlined : Icons.menu_book_outlined,
              selectedIcon: isBusinesss ? Icons.block : Icons.menu_book,
              label: isBusinesss ? l.stopList : l.navRecipes,
              index: 2,
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
            _NavItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: l.navSettings, index: 3, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
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

  const _NavItem({required this.icon, required this.selectedIcon, required this.label, required this.index, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
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