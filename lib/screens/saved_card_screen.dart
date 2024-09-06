import 'dart:io';

import 'package:business_card_scanner/db/card_provider.dart';
import 'package:business_card_scanner/widgets/business_card_item.dart';
import 'package:business_card_scanner/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_contact_page.dart';

class SavedCardsScreen extends StatefulWidget {
  @override
  _SavedCardsScreenState createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  String searchQuery = '';

  // Dummy list of tags for the filter modal.
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Cartes de Visite Sauvegardées'),
      ),*/
      body: Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
            // Search bar with filter icon
            Row(
              children: [
                // Search field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search, color: Colors.black54),
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter button (3 dots)
                IconButton(
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: () async {
                    // Open filter modal and get selected filters
                    final result = await _openFilterBottomSheet(context);
                    if (result != null) {
                      setState(() {
                        selectedTags = result;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            // List of filtered cards
            /*Consumer<CardProvider>(
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
                          title: Text(card.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (card.position != null) Text(card.position!),
                              if (card.companyName != null) Text(card.companyName!),
                              Text('${card.emails.join('/')}'),
                              Text('${card.phoneNumbers.join('/')}'),
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
            )*/
            Expanded(
              child: Consumer<CardProvider>(
                builder: (context, cardProvider, child) {
                  final cards = cardProvider.cards;
                  final filteredCards = cards.where((card) {
                    final searchLower = searchQuery.toLowerCase();
                    // Check for search query and selected tags
                    return (card.name.toLowerCase().contains(searchLower) ||
                        (card.companyName != null &&
                            card.companyName!
                                .toLowerCase()
                                .contains(searchLower)) ||
                        card.phoneNumbers.any((phone) =>
                            phone.toLowerCase().contains(searchLower)) ||
                        card.emails.any((email) =>
                            email.toLowerCase().contains(searchLower))) &&
                        (selectedTags.isEmpty || selectedTags.contains(card.tag));
                  }).toList();

                  if (filteredCards.isEmpty) {
                    return const Center(
                      child: Text('No business cards found.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      return BusinessCardItem(card: card);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open filter modal bottom sheet
  // Function to open filter modal bottom sheet and return selected tags
  Future<List<String>?> _openFilterBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterBottomSheet(),
    );

    if (result != null) {
      setState(() {
        // Appliquer les filtres et tri en fonction des résultats
        final selectedTags = result['selectedTags'];
        final sortBy = result['sortBy'];
        final isAscending = result['isAscending'];

        print(selectedTags);
        print(sortBy);
        print(isAscending);
        // Utilisez ces valeurs pour filtrer et trier vos cartes
      });
    }

    /*showModalBottomSheet<List<String>>(
      context: context,
      builder: (context) {
        List<String> tempSelectedTags = List.from(selectedTags);
        return _buildFilterModal(context, tempSelectedTags);
      },
    );*/
  }
}
