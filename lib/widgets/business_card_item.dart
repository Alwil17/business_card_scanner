import 'dart:io';

import 'package:business_card_scanner/models/business_card.dart';
import 'package:flutter/material.dart';

class BusinessCardItem extends StatelessWidget {
  final BusinessCard card;

  BusinessCardItem({required this.card});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () => Navigator.pushNamed(context, '/view', arguments: {'card': card}),child: Card(
      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(card.imagePath), // Assuming you store the image path
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            // Card details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and company
                  Text(
                    card.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                      visible: card.position != null,
                      child: Text(
                        card.position ?? '',
                        style:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                      )),
                  Visibility(
                      visible: card.position != null,
                      child: const SizedBox(height: 5)),
                  const SizedBox(height: 5),
                  // Email and phone
                  Text(
                    card.emails.isNotEmpty ? card.emails.first : 'No email',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    card.phoneNumbers.isNotEmpty
                        ? card.phoneNumbers.first
                        : 'No phone',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CLIENT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}
