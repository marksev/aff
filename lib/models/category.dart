import 'package:flutter/material.dart';

class CategoryData {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final List<String> affirmations;

  const CategoryData({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.affirmations,
  });
}
