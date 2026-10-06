import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'custom_menu_drawer.dart';
import '../../main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onRefresh;
  final bool showBackArrow;

  const CustomAppBar({super.key, this.onRefresh, this.showBackArrow = true});

  @override
  Widget build(BuildContext context) {
    final canPop = showBackArrow && (ModalRoute.of(context)?.canPop ?? false);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leadingWidth: canPop ? 56 : 140, // Enough width for the logo if not popping
      leading: canPop
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            )
          : Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: Image.asset(
                'assets/logo/uk_logo_white_bg_1584x672.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
      title: canPop
          ? Image.asset(
              'assets/logo/uk_logo_white_bg_1584x672.png',
              height: 32,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            )
          : SizedBox.shrink(),
      centerTitle: false,
      actions: [
        if (onRefresh != null)
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onSurface),
            onPressed: onRefresh,
          ),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: appThemeNotifier,
          builder: (context, currentMode, _) {
            final isDark = currentMode == ThemeMode.dark;
            return IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () {
                appThemeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              },
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(right: 4),
          child: IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => _showNotificationsBottomSheet(context),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 12),
          child: IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => _showMenuBottomSheet(context),
          ),
        ),
      ],
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text('Notifications', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: Icon(Icons.check, color: Colors.blue)),
                title: Text('Lead Approved', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                subtitle: Text('Ramesh Kumar was approved.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.green.shade100, child: Icon(Icons.monetization_on, color: Colors.green)),
                title: Text('Points Earned', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                subtitle: Text('You earned +50 points today.', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMenuBottomSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: EdgeInsets.zero,
            viewInsets: EdgeInsets.zero,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height,
              child: const CustomMenuDrawer(),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
