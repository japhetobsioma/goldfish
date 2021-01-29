import 'package:flutter/material.dart';

class CustomCard {
  const CustomCard({
    this.cardTitle,
    this.cardSubtitle,
    this.background,
    this.illustration,
  });

  final String cardTitle;
  final String cardSubtitle;
  final LinearGradient background;
  final String illustration;
}

final welcomeScreenCards = const [
  CustomCard(
    cardTitle: 'Hydrate',
    cardSubtitle: 'Motivates you to drink water',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF00AEFF),
        Color(0xFF0076FF),
      ],
    ),
    illustration: 'energizer.svg',
  ),
  CustomCard(
    cardTitle: 'Gamify',
    cardSubtitle: 'Enjoy your drinking habit',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF00AEFF),
        Color(0xFF0076FF),
      ],
    ),
    illustration: 'fish_bowl.svg',
  ),
  CustomCard(
    cardTitle: 'History',
    cardSubtitle: 'Check your daily water intake',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF00AEFF),
        Color(0xFF0076FF),
      ],
    ),
    illustration: 'personal_goals.svg',
  ),
  CustomCard(
    cardTitle: 'Notifications',
    cardSubtitle: 'Get notified for the better',
    background: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF00AEFF),
        Color(0xFF0076FF),
      ],
    ),
    illustration: 'my_notifications.svg',
  ),
];
