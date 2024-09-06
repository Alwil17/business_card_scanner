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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Carte de visite affichée
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.network(
                      'https://www.reallygreatsite.com/qr.png'), // Remplacer par une image de carte
                  ListTile(
                    title: Text(card.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(card.position!),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(card.phoneNumbers.first),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(card.emails.first),
                  ),
                  ListTile(
                    leading: const Icon(Icons.web),
                    title: Text(card.website!),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(card.address!),
                  ),
                ],
              ),
            ),

            // Actions avec les icônes pour passer un appel, envoyer un SMS, email, etc.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.phone, color: Colors.blue),
                  onPressed: () {
                    _launchUrl('tel:${card.phoneNumbers.first}');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.blue),
                  onPressed: () {
                    _launchUrl('sms:${card.phoneNumbers.first}');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.blue),
                  onPressed: () {
                    _launchUrl('mailto:${card.emails.first}');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.web, color: Colors.blue),
                  onPressed: () {
                    _launchUrl(card.website!);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.blue),
                  onPressed: () {
                    _launchUrl(
                        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(card.address!)}');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tags (comme "Friend", "Investor")
            Wrap(
              spacing: 8.0,
              children: card.tags!.map((tag) {
                return Chip(
                  label: Text(tag),
                );
              }).toList(),
            ),

            // Autres détails (Note, Full Name, Company)
            ListTile(
              title: const Text('Note'),
              subtitle: Text(card.note!),
            ),
            ListTile(
              title: const Text('Full Name'),
              subtitle: Text(card.name),
            ),
            ListTile(
              title: const Text('Company'),
              subtitle: Text(card.companyName!),
            ),
          ],
        ),
      ),
    );
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