import 'package:flutter/material.dart';

class CardData {
  Widget title;
  IconData icon;
  Widget widget;

  CardData({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

Widget buildCard(CardData cardData) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(cardData.icon),
              ),
              Flexible(
                child: cardData.title,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: cardData.widget),
        ],
      ),
    ),
  );
}
