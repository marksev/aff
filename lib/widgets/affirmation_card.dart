import 'package:flutter/material.dart';
import '../models/category.dart';

/// Full-screen affirmation page shown inside a vertical PageView.
///
/// Receives its [isFavorite] state and callbacks from the parent screen so
/// the widget itself stays stateless with respect to business logic.
class AffirmationCard extends StatefulWidget {
  final CategoryData category;
  final String affirmation;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final int pageIndex;
  final int totalPages;

  const AffirmationCard({
    super.key,
    required this.category,
    required this.affirmation,
    required this.isFavorite,
    required this.onFavorite,
    required this.onShare,
    required this.pageIndex,
    required this.totalPages,
  });

  @override
  State<AffirmationCard> createState() => _AffirmationCardState();
}

class _AffirmationCardState extends State<AffirmationCard>
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
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void didUpdateWidget(AffirmationCard oldWidget) {
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
            // ── Header ─────────────────────────────────────────────────────
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
                  const SizedBox(width: 48), // balance back button
                ],
              ),
            ),

            // ── Page indicator ─────────────────────────────────────────────
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

            // ── Affirmation text ───────────────────────────────────────────
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

            // ── Swipe hint ─────────────────────────────────────────────────
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

            // ── Action buttons ─────────────────────────────────────────────
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
