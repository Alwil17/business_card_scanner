import 'dart:io';

import 'package:business_card_scanner/db/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_contact_page.dart';

class SavedCardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartes de Visite Sauvegardées'),
      ),
      body: Consumer<CardProvider>(
        builder: (context, cardProvider, child) {
          final cards = cardProvider.cards;
          if (cards.isEmpty) {
            return Center(child: Text('Aucune carte de visite enregistrée'));
          } else {
            return ListView.builder(
              itemCount: cardProvider.cards.length,
              itemBuilder: (context, index) {
                final card = cardProvider.cards[index];
                return Card(
                  child: ListTile(
                    title: Text(card.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (card.position != null) Text(card.position!),
                        if (card.companyName != null) Text(card.companyName!),
                        if (card.website != null)
                          Text('Site: ${card.website!}'),
                        if (card.address != null)
                          Text('Adresse: ${card.address!}'),
                        Text('Email: ${card.emails.join(', ')}'),
                        Text('Téléphone: ${card.phoneNumbers.join(', ')}'),
                      ],
                    ),
                    leading: card.imagePath.isNotEmpty
                        ? Image.file(File(card.imagePath))
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditContactPage(card: card, scannedText: ""),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        cardProvider.deleteCard(card.id!);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
