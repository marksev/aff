import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/affirmations_data.dart';
import '../providers/favorites_provider.dart';
import '../services/preferences_service.dart';
import '../widgets/affirmation_card.dart';

class AffirmationScreen extends StatefulWidget {
  final int categoryIndex;
  final int initialPage;

  const AffirmationScreen({
    super.key,
    required this.categoryIndex,
    this.initialPage = 0,
  });

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  late final PageController _pageController;

  CategoryData get _category => categories[widget.categoryIndex];

  String _affirmationId(int affirmationIndex) =>
      '${widget.categoryIndex}_$affirmationIndex';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    _trackView(widget.initialPage);
  }

  Future<void> _trackView(int index) async {
    await PreferencesService.incrementViewCount(_affirmationId(index));
  }

  void _share(int index) {
    final text = _category.affirmations[index];
    Share.share('"$text"\n\n— Daily Affirmations App');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _category.affirmations.length,
      onPageChanged: (index) => _trackView(index),
      itemBuilder: (context, index) {
        final id = _affirmationId(index);
        return AffirmationCard(
          category: _category,
          affirmation: _category.affirmations[index],
          isFavorite: favoritesProvider.isFavorite(id),
          onFavorite: () =>
              context.read<FavoritesProvider>().toggleFavorite(id),
          onShare: () => _share(index),
          pageIndex: index,
          totalPages: _category.affirmations.length,
        );
      },
    );
  }
}
