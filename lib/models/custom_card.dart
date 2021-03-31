import 'package:flutter/material.dart';

class CustomCard {
  const CustomCard({
    @required this.cardTitle,
    @required this.cardSubtitle,
    @required this.background,
    @required this.illustration,
  });

  final String cardTitle;
  final String cardSubtitle;
  final LinearGradient background;
  final String illustration;
}
