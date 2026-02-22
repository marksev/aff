import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../data/affirmations_data.dart';
import '../services/preferences_service.dart';

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
  late int _currentPage;
  final Map<String, bool> _favoriteCache = {};

  CategoryData get _category => categories[widget.categoryIndex];

  String _affirmationId(int affirmationIndex) =>
      '${widget.categoryIndex}_$affirmationIndex';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
    _loadFavorites();
    _trackView(widget.initialPage);
  }

  Future<void> _loadFavorites() async {
    final favorites = await PreferencesService.getFavorites();
    if (!mounted) return;
    setState(() {
      for (int i = 0; i < _category.affirmations.length; i++) {
        final id = _affirmationId(i);
        _favoriteCache[id] = favorites.contains(id);
      }
    });
  }

  Future<void> _trackView(int index) async {
    await PreferencesService.incrementViewCount(_affirmationId(index));
  }

  Future<void> _toggleFavorite(int index) async {
    final id = _affirmationId(index);
    await PreferencesService.toggleFavorite(id);
    if (!mounted) return;
    setState(() {
      _favoriteCache[id] = !(_favoriteCache[id] ?? false);
    });
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
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _category.affirmations.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
          _trackView(index);
        },
        itemBuilder: (context, index) {
          return _AffirmationPage(
            category: _category,
            affirmation: _category.affirmations[index],
            isFavorite: _favoriteCache[_affirmationId(index)] ?? false,
            onFavorite: () => _toggleFavorite(index),
            onShare: () => _share(index),
            pageIndex: index,
            totalPages: _category.affirmations.length,
          );
        },
      ),
    );
  }
}

class _AffirmationPage extends StatefulWidget {
  final CategoryData category;
  final String affirmation;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final int pageIndex;
  final int totalPages;

  const _AffirmationPage({
    required this.category,
    required this.affirmation,
    required this.isFavorite,
    required this.onFavorite,
    required this.onShare,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<_AffirmationPage> createState() => _AffirmationPageState();
}

class _AffirmationPageState extends State<_AffirmationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void didUpdateWidget(_AffirmationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.affirmation != widget.affirmation) {
      _fadeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.category.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Back button and header
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  // Spacer to balance the back button
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Page indicator
            Positioned(
              top: 56,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.pageIndex + 1} / ${widget.totalPages}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Centered affirmation text
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    '"${widget.affirmation}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

            // Swipe hint at bottom
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Icon(Icons.keyboard_arrow_up,
                      color: Colors.white54, size: 28),
                  Text(
                    'Swipe for next',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 12),
                  ),
                ],
              ),
            ),

            // Action buttons on the right
            Positioned(
              right: 16,
              bottom: 80,
              child: Column(
                children: [
                  _ActionButton(
                    icon: widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: 'Like',
                    color: widget.isFavorite ? Colors.red : Colors.white,
                    onTap: widget.onFavorite,
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    color: Colors.white,
                    onTap: widget.onShare,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
