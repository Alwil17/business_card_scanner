import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:business_card_scanner/models/business_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CardDetailScreen extends StatelessWidget {
  final BusinessCard card;

  const CardDetailScreen({Key? key, required this.card}) : super(key: key);

  // Ouvre un URL pour lancer des actions (appel, email, sms, etc.)
  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withAlpha(20),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                // Naviguer vers l'écran d'édition
                Navigator.pushNamed(context, '/edit', arguments: card);
              } else if (value == 'delete') {
                // Action de suppression
                _deleteCard(context);
              } else if (value == 'export') {
                // Action d'exportation
                _exportCard(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete', 'Export'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice.toLowerCase(),
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImageContainer(),
            const SizedBox(height: 10),
            _buildCardActions(),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Tags
                    _buildInfoTitle("Tags"),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: card.tags.map((tag) {
                        return Chip(
                          label: Text(
                            tag.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: StadiumBorder(side: BorderSide(color: Colors.blue.withAlpha(50), width: 0)),
                          backgroundColor: Colors.blue.withAlpha(50), // Couleur du tag
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Section Note
                    _buildInfoRow("Note", card.note ?? ""),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildCardInfos(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.red,
          image: DecorationImage(
            image: Image.file(File(card.imagePath)).image,
            // replace with your image asset
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
    ); // Remplacer par une image de carte
  }

  Widget _buildCardActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton.filled(
          icon: const Icon(Icons.phone),
          onPressed: () {
            _launchUrl('tel:${card.phoneNumbers.first}');
          },
          style: IconButton.styleFrom(backgroundColor: Colors.blue),
        ),
        IconButton.filled(
          icon: const Icon(Icons.message),
          onPressed: () {
            _launchUrl('sms:${card.phoneNumbers.first}');
          },
          style: IconButton.styleFrom(backgroundColor: Colors.blue),
        ),
        IconButton.filled(
          icon: const Icon(Icons.email),
          onPressed: () {
            _launchUrl('mailto:${card.emails.first}');
          },
          style: IconButton.styleFrom(backgroundColor: Colors.blue),
        ),
        Visibility(visible: (card.website != null && card.website!.isNotEmpty),child: IconButton.filled(
          icon: const Icon(Icons.web),
          onPressed: () {
            _launchUrl(card.website!);
          },
          style: IconButton.styleFrom(backgroundColor: Colors.blue),
        )),

        Visibility(visible: (card.address != null && card.address!.isNotEmpty),child: IconButton.filled(
          icon: const Icon(Icons.location_on),
          onPressed: () {
            _launchUrl(
                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(card.address ?? "")}');
          },
          style: IconButton.styleFrom(backgroundColor: Colors.blue),
        ))

      ],
    );
  }

  // Fonction pour créer une ligne d'information avec une ligne séparatrice
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoTitle(label),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        const Divider(thickness: 1), // Ligne séparatrice
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCardInfos() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Full Name
        _buildInfoRow("Full name", card.name),

        // Section Company
        Visibility(visible: (card.companyName != null && card.companyName!.isNotEmpty),child: _buildInfoRow("Company", card.companyName ?? "")),

        // Section Position
        Visibility(visible: (card.position != null && card.position!.isNotEmpty),child: _buildInfoRow("Position", card.position ?? "")),
        // Section contacts
        _buildInfoRow("Contact(s)", card.phoneNumbers.join(" / ")),

        // Section emails
        _buildInfoRow("Email(s)", card.emails.join(" / ")),

        // Section Adresse
        Visibility(visible: (card.address != null && card.address!.isNotEmpty),child: _buildInfoRow("Adresse", card.address ?? "")),

        // Section Website
        Visibility(visible: (card.website != null && card.website!.isNotEmpty),child: _buildInfoRow("Website", card.website ?? "")),
      ],);
  }

  // Fonction de suppression de la carte
  void _deleteCard(BuildContext context) {
    // Code de suppression de la carte
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Suppression logique ici
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Appel à la fonction de suppression réelle
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Fonction d'exportation de la carte
  void _exportCard(BuildContext context) {
    // Code pour exporter la carte (ex: en PDF, etc.)
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Export Card'),
        content: Text('Card exported successfully!'),
      ),
    );
  }
}
