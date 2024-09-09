import 'package:flutter/material.dart';

class TagFormModal extends StatefulWidget {
  final String? initialName;
  final void Function(String) onSubmit;

  TagFormModal({this.initialName, required this.onSubmit});

  @override
  _TagFormModalState createState() => _TagFormModalState();
}

class _TagFormModalState extends State<TagFormModal> {
  late TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _tagController,
            decoration: InputDecoration(
              labelText: 'Nom du Tag',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _tagController.clear();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_tagController.text.isNotEmpty) {
                widget.onSubmit(_tagController.text); // Sauvegarder le tag
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}