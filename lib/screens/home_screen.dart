import 'package:business_card_scanner/models/business_card.dart';
import 'package:business_card_scanner/screens/camera_screen.dart';
import 'package:business_card_scanner/screens/card_screen_details.dart';
import 'package:business_card_scanner/screens/display_picture_screen.dart';
import 'package:business_card_scanner/screens/edit_contact_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => CameraScreen();
            break;
          case '/display':
            builder = (BuildContext context) => DisplayPictureScreen(
                  imagePath: settings.arguments as String,
                );
            break;

          case '/edit':
            final args = settings.arguments as Map<String, dynamic>;
            final BusinessCard card = args['card'];
            final String scannedText = args['scannedText'];
            builder = (BuildContext context) => EditContactPage(
                  card: card,
                  scannedText: scannedText,
                );
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
