import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _favoritesKey = 'favorites';
  static const String _viewCountPrefix = 'view_count_';

  static Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey) ?? [];
    return list.toSet();
  }

  static Future<void> toggleFavorite(String affirmationId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favoritesKey) ?? [];
    if (list.contains(affirmationId)) {
      list.remove(affirmationId);
    } else {
      list.add(affirmationId);
    }
    await prefs.setStringList(_favoritesKey, list);
  }

  static Future<bool> isFavorite(String affirmationId) async {
    final favorites = await getFavorites();
    return favorites.contains(affirmationId);
  }

  static Future<int> getViewCount(String affirmationId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_viewCountPrefix$affirmationId') ?? 0;
  }

  static Future<void> incrementViewCount(String affirmationId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt('$_viewCountPrefix$affirmationId') ?? 0;
    await prefs.setInt('$_viewCountPrefix$affirmationId', current + 1);
  }

  static Future<Map<String, int>> getAllViewCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith(_viewCountPrefix))
        .toList();
    final Map<String, int> counts = {};
    for (final key in keys) {
      final id = key.replaceFirst(_viewCountPrefix, '');
      counts[id] = prefs.getInt(key) ?? 0;
    }
    return counts;
  }
}
