import 'package:business_card_scanner/db/card_provider.dart';
import 'package:business_card_scanner/db/tag_provider.dart';
import 'package:business_card_scanner/models/business_card.dart';
import 'package:business_card_scanner/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:provider/provider.dart';

class EditContactPage extends StatefulWidget {
  final String scannedText;
  final BusinessCard card;

  EditContactPage({
    required this.card,
    required this.scannedText
  });

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController _nameController;
  late List<TextEditingController> _phoneControllers;
  late List<TextEditingController> _emailControllers;
  List<Tag> _availableTags = []; // Liste des tags disponibles
  List<Tag> _selectedTags = []; // Liste des tags sélectionnés

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.card.name);
    _phoneControllers = widget.card.phoneNumbers.map((phone) => TextEditingController(text: phone)).toList();
    _emailControllers = widget.card.emails.map((email) => TextEditingController(text: email)).toList();

    // Charger les tags existants via un Provider ou une base de données
    _loadTags();
  }

  Future<void> _loadTags() async {
    // Charger les tags depuis la base de données ou via le provider
    List<Tag> tags = Provider.of<TagProvider>(context, listen: false).tags;

    setState(() {
      _availableTags = tags;
      _selectedTags = widget.card.tags; // Prendre les tags associés à la carte
    });
  }
  @override
  void dispose() {
    _nameController.dispose();
    _phoneControllers.forEach((controller) => controller.dispose());
    _emailControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveContact() {
    BusinessCard scannedCard = widget.card;
    scannedCard.name = _nameController.text;
    scannedCard.phoneNumbers = _phoneControllers.map((controller) => controller.text).toList();
    scannedCard.emails = _emailControllers.map((controller) => controller.text).toList();
    scannedCard.tags = _selectedTags; // Enregistrer les tags sélectionnés

    // Utiliser Provider pour ajouter la carte
    Provider.of<CardProvider>(context, listen: false).addCard(scannedCard);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact enregistré avec succès !')));
  }

  // Construction de la liste des tags sous forme de CheckboxListTile
  Widget _buildTagSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)),
        ..._availableTags.map((tag) {
          return CheckboxListTile(
            title: Text(tag.name),
            value: _selectedTags.contains(tag),
            onChanged: (bool? isSelected) {
              setState(() {
                if (isSelected == true) {
                  _selectedTags.add(tag);
                } else {
                  _selectedTags.remove(tag);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPhoneFields() {
    return Column(
      children: _phoneControllers.map((controller) {
        return TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Téléphone'),
          keyboardType: TextInputType.phone,
        );
      }).toList(),
    );
  }

  Widget _buildEmailFields() {
    return Column(
      children: _emailControllers.map((controller) {
        return TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.blue),
            onPressed: _saveContact,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 16),
            const Text('Téléphones', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)),
            _buildPhoneFields(),
            const SizedBox(height: 16),
            const Text('Emails', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)),
            _buildEmailFields(),
            const SizedBox(height: 16),
            _buildTagSelection(),
          ],
        ),
      ),
    );
  }
}
