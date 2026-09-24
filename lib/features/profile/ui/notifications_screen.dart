import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/event_model.dart';
import '../../../core/models/temple_model.dart';
import '../../../core/services/event_repository.dart';
import '../../../core/services/temple_repository.dart';
import '../../../core/session/user_session.dart';
import '../../event_details/ui/event_details_screen.dart';

/// Role-aware notifications: a temple account sees recent bookings across
/// its own events, a devotee sees upcoming events at the temples they've
/// saved — both built from data that already exists, not placeholder text.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserSession>();
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: session.isTemple
          ? _RecentBookings(uid: session.uid ?? '')
          : _SavedTempleReminders(savedTempleIds: session.savedTempleIds),
    );
  }
}

class _RecentBookings extends StatelessWidget {
  final String uid;
  const _RecentBookings({required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventAttendeeActivity>>(
      future: EventRepository().recentAttendeesForOwner(uid, limit: 20),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final bookings = snapshot.data ?? const <EventAttendeeActivity>[];
        if (bookings.isEmpty) {
          return const Center(child: Text('No recent registrations yet.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: booking.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' registered for ${booking.eventTitle}.'),
                  ],
                ),
              ),
              subtitle: Text(_timeAgo(booking.bookedAt)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: booking.eventId)),
              ),
            );
          },
        );
      },
    );
  }
}

class _SavedTempleReminders extends StatelessWidget {
  final List<String> savedTempleIds;
  const _SavedTempleReminders({required this.savedTempleIds});

  @override
  Widget build(BuildContext context) {
    if (savedTempleIds.isEmpty) {
      return const Center(child: Text('Save a temple to get reminders about its events.'));
    }
    return FutureBuilder<List<TempleModel>>(
      future: TempleRepository().fetchByIds(savedTempleIds),
      builder: (context, templeSnapshot) {
        if (templeSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final savedTemples = templeSnapshot.data ?? const <TempleModel>[];
        final ownerIds = savedTemples.map((t) => t.ownerId).toSet();
        final templeNameByOwner = {for (final t in savedTemples) t.ownerId: t.name};
        if (ownerIds.isEmpty) {
          return const Center(child: Text('Save a temple to get reminders about its events.'));
        }
        return StreamBuilder<List<EventModel>>(
          stream: EventRepository().watchAll(),
          builder: (context, eventSnapshot) {
            final events = (eventSnapshot.data ?? const <EventModel>[])
                .where((e) => e.isUpcoming && ownerIds.contains(e.ownerId))
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
            if (events.isEmpty) {
              return const Center(child: Text('No upcoming events at your saved temples yet.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  leading: const Icon(Icons.event_available),
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${templeNameByOwner[event.ownerId] ?? 'A saved temple'} • ${event.dateText} • ${event.startTime}',
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

String _timeAgo(DateTime? dt) {
  if (dt == null) return '';
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
}
