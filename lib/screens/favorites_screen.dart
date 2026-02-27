import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/affirmations_data.dart';
import '../providers/favorites_provider.dart';
import 'affirmation_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favIds = context.watch<FavoritesProvider>().favorites;

    // Resolve IDs → (categoryIndex, affirmationIndex) pairs
    final items = favIds
        .map((id) {
          final parts = id.split('_');
          if (parts.length != 2) return null;
          final catIdx = int.tryParse(parts[0]);
          final affIdx = int.tryParse(parts[1]);
          if (catIdx == null ||
              affIdx == null ||
              catIdx >= categories.length ||
              affIdx >= categories[catIdx].affirmations.length) return null;
          return _FavoriteItem(
              id: id, categoryIndex: catIdx, affirmationIndex: affIdx);
        })
        .whereType<_FavoriteItem>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: items.isEmpty
          ? const _EmptyFavorites()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final category = categories[item.categoryIndex];
                final affirmation =
                    category.affirmations[item.affirmationIndex];
                return _FavoriteCard(
                  category: category,
                  affirmation: affirmation,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AffirmationScreen(
                        categoryIndex: item.categoryIndex,
                        initialPage: item.affirmationIndex,
                      ),
                    ),
                  ),
                  onRemove: () => context
                      .read<FavoritesProvider>()
                      .toggleFavorite(item.id),
                );
              },
            ),
    );
  }
}

class _FavoriteItem {
  final String id;
  final int categoryIndex;
  final int affirmationIndex;

  const _FavoriteItem({
    required this.id,
    required this.categoryIndex,
    required this.affirmationIndex,
  });
}

class _FavoriteCard extends StatelessWidget {
  final CategoryData category;
  final String affirmation;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.category,
    required this.affirmation,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            category.gradient.first.withOpacity(0.15),
            category.gradient.last.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: category.gradient.first.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: category.gradient),
            shape: BoxShape.circle,
          ),
          child: Icon(category.icon, color: Colors.white, size: 22),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            color: category.gradient.first,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '"$affirmation"',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red, size: 22),
          onPressed: onRemove,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any affirmation\nto save it here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
