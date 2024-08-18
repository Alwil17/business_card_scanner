import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class EditContactPage extends StatefulWidget {
  final String scannedText;
  final String name;
  final List<String> phones;
  final List<String> emails;

  EditContactPage({
    required this.scannedText,
    required this.name,
    required this.phones,
    required this.emails,
  });

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController _nameController;
  late List<TextEditingController> _phoneControllers;
  late List<TextEditingController> _emailControllers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneControllers = widget.phones.map((phone) => TextEditingController(text: phone)).toList();
    _emailControllers = widget.emails.map((email) => TextEditingController(text: email)).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneControllers.forEach((controller) => controller.dispose());
    _emailControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveContact() {
    final newContact = Contact(
      givenName: _nameController.text,
      phones: _phoneControllers.map((controller) => Item(label: 'mobile', value: controller.text)).toList(),
      emails: _emailControllers.map((controller) => Item(label: 'work', value: controller.text)).toList(),
    );

    ContactsService.addContact(newContact);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact enregistré avec succès !')));
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
          ],
        ),
      ),
    );
  }
}
