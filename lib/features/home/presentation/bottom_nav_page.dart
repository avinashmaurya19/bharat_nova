import 'package:bharat_nova/widgets/app_colors.dart';
import 'package:bharat_nova/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/bottom_nav_cubit.dart';
import 'home_page.dart';

class BottomNavPage extends StatelessWidget {
  const BottomNavPage({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    _NavPlaceholderPage(title: 'Search'),
    _NavPlaceholderPage(title: 'Bharat'),
    _NavPlaceholderPage(title: 'Activity'),
    _NavPlaceholderPage(title: 'Notifications'),
    _NavPlaceholderPage(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            extendBody: true,
            body: IndexedStack(index: state.selectedIndex, children: _pages),
            bottomNavigationBar: BottomNavBar(
              currentIndex: state.selectedIndex,
              onTap: (value) => context.read<BottomNavCubit>().selectTab(value),
            ),
            floatingActionButton: const _CenterAddButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  const _CenterAddButton();

  static const Color _navBlue = Color(0xFF121A76);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 25),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: AppColors.white,
            onPressed: () {},
            elevation: 0,
            shape: const CircleBorder(),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _navBlue,
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 30),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  static const Color _navBlue = Color(0xFF121A76);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              isActive: currentIndex == 0,
              activeColor: _navBlue,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.search_rounded,
              isActive: currentIndex == 1,
              activeColor: _navBlue,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.branding_watermark_outlined,
              isActive: currentIndex == 2,
              activeColor: _navBlue,
              onTap: () => onTap(2),
            ),
            const SizedBox(width: 70),
            _NavItem(
              icon: Icons.history_toggle_off_rounded,
              isActive: currentIndex == 3,
              activeColor: _navBlue,
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.notifications_none_rounded,
              isActive: currentIndex == 4,
              activeColor: _navBlue,
              onTap: () => onTap(4),
            ),
            _NavAvatar(
              isActive: currentIndex == 5,
              activeColor: _navBlue,
              onTap: () => onTap(5),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        child: Icon(
          icon,
          color: isActive
              ? activeColor
              : AppColors.secondoryText.withValues(alpha: 0.62),
          size: 30,
        ),
      ),
    );
  }
}

class _NavAvatar extends StatelessWidget {
  const _NavAvatar({
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        onTap: onTap,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? activeColor : AppColors.borderColor,
                width: 1.5,
              ),
            ),
            child: Icon(Icons.person, color: AppColors.borderColor, size: 18),
          ),
        ),
      ),
    );
  }
}

class _NavPlaceholderPage extends StatelessWidget {
  const _NavPlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          '$title Page',
          style: AppTextStyle.semiBoldStyle(
            fontSize: 18,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
