import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/event_model.dart';
import '../../../core/services/event_repository.dart';
import '../../../core/session/user_session.dart';
import '../provider/event_details_provider.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventDetailsProvider(eventId),
      child: StreamBuilder<EventModel?>(
        stream: EventRepository().watchById(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final event = snapshot.data;
          if (event == null) {
            return const Scaffold(body: Center(child: Text('This event could not be found.')));
          }
          return _EventDetailsContent(event: event);
        },
      ),
    );
  }
}

class _EventDetailsContent extends StatelessWidget {
  final EventModel event;
  const _EventDetailsContent({required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isSmall = size.width < 360;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48.0 : (isSmall ? 16.0 : 24.0),
          vertical: isSmall ? 16.0 : 24.0,
        ),
        child: Column(
          children: [
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(context),
                        const SizedBox(height: 48),
                        _buildAboutSection(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _buildEventPassSidebar(context),
                        const SizedBox(height: 48),
                        _buildCommunitySection(context),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context),
                  const SizedBox(height: 32),
                  _buildEventPassSidebar(context),
                  const SizedBox(height: 48),
                  _buildAboutSection(context),
                  const SizedBox(height: 48),
                  _buildCommunitySection(context),
                  const SizedBox(height: 40),
                ],
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Darshana',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
      ),
      actions: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA0ke83SrFkdXrGmkeL6uEOl61VI6UdfzekOEvq_01FdPh5SSwDzS85X-nQVNl9UjREljzOzzHCHiLckV7-3M_xiT2dSm9-WYGiTJxyXP_odU7XPl7CYa9ywZMmgarhKeeVSK1lncmT9oNteXO864nno5jVAPPtp3eTqPyROxbqqfO80WAOHs5CIsoZOudNDM240qB1kkvXercDOwoPfR_XkTswDp3ZsWenMa-ogGrIHKxOh67mVveVTBmSZewDYfvClvBldWTvB78',
            ),
            radius: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final heroHeight = size.height < 700 ? 280.0 : 400.0;
    return Column(
      children: [
        Container(
          height: heroHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            image: DecorationImage(
              image: CachedNetworkImageProvider(event.imageUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black87, Colors.black26, Colors.transparent],
              ),
            ),
            padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      event.badge.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 22 : null,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: size.width < 400 ? 2 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isSmall ? 2.0 : 2.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildInfoTile(context, Icons.calendar_today, 'DATE', event.dateText),
            _buildInfoTile(context, Icons.schedule, 'STARTS AT', event.startTime),
            _buildInfoTile(context, Icons.location_on, 'VENUE', event.venue),
            _buildInfoTile(context, Icons.hourglass_empty, 'DURATION', event.durationText),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEventPassSidebar(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Pass',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entry', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12)),
                    Text(
                      event.price > 0 ? '₹${event.price.toStringAsFixed(0)}' : 'Free',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              StreamBuilder<int>(
                stream: EventRepository().watchAttendeeCount(event.id),
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  final capacity = event.capacity;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      capacity != null ? '$count/$capacity GOING' : '$count GOING',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Consumer<UserSession>(
            builder: (context, session, child) {
              final uid = session.uid;
              if (uid == null) return const SizedBox.shrink();
              return StreamBuilder<bool>(
                stream: EventRepository().watchIsAttending(event.id, uid),
                builder: (context, attendingSnapshot) {
                  final isAttending = attendingSnapshot.data ?? false;
                  return Consumer<EventDetailsProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: (provider.isBooking || isAttending)
                              ? null
                              : () => provider.bookTicket(uid: uid, name: session.displayName),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: provider.isBooking
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  isAttending ? 'YOU\'RE GOING' : 'GET ENTRY PASS',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'About this event',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          event.description.isEmpty
              ? 'The organizer hasn\'t added more details for this event yet.'
              : event.description,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.6, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCommunitySection(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Container(
      padding: EdgeInsets.all(isSmall ? 20.0 : 32.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.groups, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Who else is attending',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          StreamBuilder<int>(
            stream: EventRepository().watchAttendeeCount(event.id),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Text(
                count == 0 ? 'No one has booked yet — be the first!' : '$count ${count == 1 ? 'person is' : 'people are'} going',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              );
            },
          ),
          const SizedBox(height: 32),
          StreamBuilder<List<EventComment>>(
            stream: EventRepository().watchComments(event.id),
            builder: (context, snapshot) {
              final comments = snapshot.data ?? const [];
              if (comments.isEmpty) {
                return Text(
                  'No comments yet. Share your excitement!',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < comments.length; i++) ...[
                    if (i > 0) const SizedBox(height: 24),
                    _buildCommentItem(context, comments[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          _CommentComposer(eventId: event.id),
        ],
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, EventComment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          child: Text(comment.name.isNotEmpty ? comment.name[0].toUpperCase() : '?'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(comment.text, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(_relativeTime(comment.createdAt), style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 10)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _CommentComposer extends StatefulWidget {
  final String eventId;
  const _CommentComposer({required this.eventId});

  @override
  State<_CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<_CommentComposer> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send(EventDetailsProvider provider, UserSession session) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final uid = session.uid;
    if (uid == null) return;
    setState(() => _sending = true);
    await provider.addComment(uid: uid, name: session.displayName, text: text);
    _controller.clear();
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EventDetailsProvider>();
    final session = context.watch<UserSession>();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: !_sending,
            decoration: InputDecoration(
              hintText: 'Share your excitement...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: _sending
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: Colors.white),
            onPressed: _sending ? null : () => _send(provider, session),
          ),
        ),
      ],
    );
  }
}
