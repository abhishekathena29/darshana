import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../session/user_session.dart';
import 'morphing_top_nav.dart';
import 'ai_side_button.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/events/ui/events_screen.dart';
import '../../features/sacred_path/ui/sacred_path_screen.dart';
import '../../features/host_dashboard/ui/host_dashboard_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/ai_assistant/ui/ai_assistant_screen.dart';

/// The persistent application shell.
///
/// Owns the role-aware destination list, the scroll-driven [MorphingTopNav],
/// the [AISideButton] and an [IndexedStack] of the main pages. Detail screens
/// (event details, temple profile, …) are pushed full-screen on top of it.
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;
  double _progress = 0;

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    final p = (n.metrics.pixels / MorphingTopNav.collapseDistance)
        .clamp(0.0, 1.0);
    if ((p - _progress).abs() > 0.002) {
      setState(() => _progress = p);
    }
    return false;
  }

  void _select(int i) {
    if (i == _index) return;
    setState(() {
      _index = i;
      _progress = 0; // every page opens in the expanded "grid" state
    });
  }

  void _openAi() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserSession>();
    final isTemple = session.isTemple;
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    final topInset = media.padding.top;
    final navExpandedHeight = topInset + MorphingTopNav.expandedContentHeight;

    final destinations = <NavDestinationData>[
      NavDestinationData(
        icon: isTemple ? Icons.dashboard_rounded : Icons.home_filled,
        label: isTemple ? 'Dashboard' : 'Home',
      ),
      const NavDestinationData(icon: Icons.calendar_month, label: 'Events'),
      const NavDestinationData(icon: Icons.route, label: 'Path'),
      const NavDestinationData(icon: Icons.person, label: 'Profile'),
    ];

    final pages = <Widget>[
      isTemple
          ? HostDashboardScreen(topInset: navExpandedHeight)
          : HomeScreen(topInset: navExpandedHeight),
      EventsScreen(topInset: navExpandedHeight),
      SacredPathScreen(topInset: navExpandedHeight),
      ProfileScreen(topInset: navExpandedHeight),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: IndexedStack(index: _index, children: pages),
            ),
          ),

          // Morphing glass top navigation.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MorphingTopNav(
              progress: _progress,
              destinations: destinations,
              currentIndex: _index,
              onSelect: _select,
              onAvatar: () => _select(destinations.length - 1),
            ),
          ),

          // AI assistant side button.
          Positioned(
            right: 0,
            top: media.size.height * 0.42,
            child: SafeArea(
              left: false,
              top: false,
              bottom: false,
              child: AISideButton(onTap: _openAi),
            ),
          ),
        ],
      ),
    );
  }
}
