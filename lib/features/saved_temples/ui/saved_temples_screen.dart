import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/temple_model.dart';
import '../../../core/services/temple_repository.dart';
import '../../../core/session/user_session.dart';
import '../../temple_profile/ui/temple_profile_screen.dart';

class SavedTemplesScreen extends StatelessWidget {
  const SavedTemplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserSession>();
    final savedIds = session.savedTempleIds;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved temples')),
      body: savedIds.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Temples you bookmark will show up here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            )
          : FutureBuilder<List<TempleModel>>(
              future: TempleRepository().fetchByIds(savedIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final temples = snapshot.data ?? const [];
                if (temples.isEmpty) {
                  return const Center(child: Text('No saved temples found.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: temples.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final temple = temples[index];
                    return Material(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TempleProfileScreen(templeId: temple.id),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: temple.imageUrl,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      temple.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      temple.location,
                                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
