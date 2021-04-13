import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/routes.dart';
import '../models/custom_card.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const ScreenTitle(),
              const FeaturesList(),
              const GetStarted(),
            ],
          ),
        ),
      ),
    );
  }
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Aqua – Drink Reminder',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
            color: const Color(0xFF0076FF),
          ),
        ),
        const Text(
          'Helps you to stay hydrated',
          style: TextStyle(
            fontSize: 16.0,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}

class FeaturesList extends HookWidget {
  const FeaturesList();

  @override
  Widget build(BuildContext context) {
    final currentPage = useState(0);

    return Column(
      children: [
        Text(
          'Features',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Container(
          height: 335.0,
          width: double.infinity,
          child: PageView.builder(
            itemBuilder: (context, index) {
              return Opacity(
                opacity: currentPage.value == index ? 1.0 : 0.5,
                child: Features(
                  customCard: welcomeScreenCards[index],
                ),
              );
            },
            itemCount: welcomeScreenCards.length,
            controller: PageController(
              initialPage: 0,
              viewportFraction: 0.75,
            ),
            onPageChanged: (index) {
              currentPage.value = index;
            },
          ),
        ),
        UpdateIndicators(
          currentPage: currentPage.value,
        ),
      ],
    );
  }
}

class Features extends StatelessWidget {
  const Features({@required this.customCard}) : assert(customCard != null);

  final CustomCard customCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 280.0,
          height: 280.0,
          decoration: BoxDecoration(
            color: customCard.background,
            borderRadius: BorderRadius.circular(41.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 32.0,
                  left: 32.0,
                  right: 32.0,
                ),
                child: Column(
                  children: [
                    Text(
                      customCard.cardSubtitle,
                      style: TextStyle(
                        color: Color(0xE6FFFFFF),
                        fontSize: 13.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      customCard.cardTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: SvgPicture.asset(
                  'assets/illustrations/${customCard.illustration}',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final welcomeScreenCards = const [
  CustomCard(
    cardTitle: 'Hydrate',
    cardSubtitle: 'Motivates you to drink water',
    background: Color(0xFF0076FF),
    illustration: 'energizer.svg',
  ),
  CustomCard(
    cardTitle: 'Gamify',
    cardSubtitle: 'Enjoy your drinking habit',
    background: Color(0xFF0076FF),
    illustration: 'fish_bowl.svg',
  ),
  CustomCard(
    cardTitle: 'History',
    cardSubtitle: 'Check your daily water intake',
    background: Color(0xFF0076FF),
    illustration: 'personal_goals.svg',
  ),
  CustomCard(
    cardTitle: 'Notifications',
    cardSubtitle: 'Get notified for the better',
    background: Color(0xFF0076FF),
    illustration: 'my_notifications.svg',
  ),
];

class UpdateIndicators extends StatelessWidget {
  const UpdateIndicators({@required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: welcomeScreenCards.map((customCard) {
        var index = welcomeScreenCards.indexOf(customCard);

        return Container(
          width: 7.0,
          height: 7.0,
          margin: const EdgeInsets.symmetric(
            horizontal: 6.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index ? Color(0xFF0971FE) : Color(0xFFA6AEBD),
          ),
        );
      }).toList(),
    );
  }
}

class GetStarted extends StatelessWidget {
  const GetStarted();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.pushNamed(context, createPlanRoute);
      },
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      child: const Text('Get started'),
    );
  }
}
