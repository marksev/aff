import 'package:flutter/foundation.dart';
import '../services/preferences_service.dart';

/// Manages the set of favorited affirmation IDs.
///
/// Each ID is encoded as "<categoryIndex>_<affirmationIndex>" so it can be
/// resolved back to the full text without storing duplicated strings.
class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  FavoritesProvider() {
    _loadFavorites();
  }

  /// Unmodifiable view of currently favorited IDs.
  Set<String> get favorites => Set.unmodifiable(_favorites);

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> _loadFavorites() async {
    final saved = await PreferencesService.getFavorites();
    _favorites.addAll(saved);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
    // Persist asynchronously after notifying listeners so the UI feels instant.
    await PreferencesService.toggleFavorite(id);
  }
}
