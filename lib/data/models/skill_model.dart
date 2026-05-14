import 'package:flutter/material.dart';

class SkillModel {
  final String title;
  final String description;
  final List<String> tags;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;

  const SkillModel({
    required this.title,
    required this.description,
    required this.tags,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });
}
