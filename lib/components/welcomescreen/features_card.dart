import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../../model/customcard.dart';
import '../../constants.dart';

class WelcomeScreenCard extends StatelessWidget {
  const WelcomeScreenCard({this.customCard});

  final CustomCard customCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 280.0,
          height: 280.0,
          decoration: BoxDecoration(
            gradient: customCard.background,
            borderRadius: BorderRadius.circular(41.0),
            boxShadow: [
              BoxShadow(
                color: customCard.background.colors[0].withOpacity(0.30),
                offset: Offset(0, 20),
                blurRadius: 30.0,
              ),
              BoxShadow(
                color: customCard.background.colors[1].withOpacity(0.30),
                offset: Offset(0, 20),
                blurRadius: 30.0,
              ),
            ],
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
                      style: kCardSubtitleStyle,
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      customCard.cardTitle,
                      style: kCardTitleStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: SvgPicture.asset(
                  'asset/illustrations/${customCard.illustration}',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 32.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
