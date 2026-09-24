import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/temple_model.dart';
import '../../../core/services/temple_repository.dart';
import '../../temple_profile/ui/temple_profile_screen.dart';

/// The full "Sacred Sanctuaries" gallery — every temple, not just the
/// handful featured on the home screen.
class TempleGalleryScreen extends StatelessWidget {
  const TempleGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width > 900 ? 3 : (size.width > 600 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(title: const Text('Sacred Sanctuaries')),
      body: StreamBuilder<List<TempleModel>>(
        stream: TempleRepository().watchAll(),
        builder: (context, snapshot) {
          final temples = snapshot.data ?? const <TempleModel>[];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (temples.isEmpty) {
            return const Center(child: Text('No temples have been added yet.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: temples.length,
            itemBuilder: (context, index) => _TempleTile(temple: temples[index]),
          );
        },
      ),
    );
  }
}

class _TempleTile extends StatelessWidget {
  final TempleModel temple;
  const _TempleTile({required this.temple});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TempleProfileScreen(templeId: temple.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: CachedNetworkImageProvider(temple.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                temple.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      temple.location,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
