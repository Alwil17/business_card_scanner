import 'package:business_card_scanner/models/business_card.dart';
import 'package:business_card_scanner/screens/card_screen_details.dart';
import 'package:business_card_scanner/screens/saved_card_page.dart';
import 'package:flutter/material.dart';

class SavecCardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => SavedCardsPage();
            break;
          case '/view':
            final args = settings.arguments as Map<String, dynamic>;
            final BusinessCard card = args['card'];
            builder = (BuildContext context) => CardDetailScreen(
              card: card,
            );
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
