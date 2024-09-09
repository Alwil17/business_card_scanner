import 'package:business_card_scanner/db/tag_provider.dart';
import 'package:business_card_scanner/models/tag.dart';
import 'package:business_card_scanner/widgets/tag_form_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagManagePage extends StatefulWidget {
  const TagManagePage({super.key});

  @override
  _TagManagePageState createState() => _TagManagePageState();
}

class _TagManagePageState extends State<TagManagePage> {
  final TextEditingController _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tagProvider = Provider.of<TagProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tags'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TagProvider>(
          builder: (context, tagProvider, child) {
            final tags = tagProvider.tags; // Liste des tags
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tags',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                if (tags.isEmpty)
                  const Text('Aucun tag trouvé.')
                else
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tags.map((tag) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                        ),
                        onPressed: () => _openEditTagModal(tag), // Ouvrir modal pour modifier
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${tag.name} (0)',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTagModal(), // Ouvrir modal pour ajouter un nouveau tag
        child: const Icon(Icons.add),
      ),
    );
  }

  // Modal pour ajouter un tag
  void _openAddTagModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: TagFormModal(
            onSubmit: (newTagName) {
              // Ajouter le tag via Provider
              Provider.of<TagProvider>(context, listen: false).addTag(Tag(name: newTagName));
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  // Modal pour modifier un tag
  void _openEditTagModal(Tag tag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: TagFormModal(
            initialName: tag.name,
            onSubmit: (updatedTagName) {
              // Mettre à jour le tag via Provider
              tag.name = updatedTagName;
              Provider.of<TagProvider>(context, listen: false).updateTag(tag);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, TagProvider tagProvider, Tag tag) {
    _tagController.text = tag.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tag'),
          content: TextField(
            controller: _tagController,
            decoration: InputDecoration(labelText: 'Tag name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newName = _tagController.text;
                if (newName.isNotEmpty) {
                  tagProvider.updateTag(tag);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
