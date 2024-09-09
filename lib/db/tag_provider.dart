import 'package:business_card_scanner/models/tag.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';


class TagProvider with ChangeNotifier {
  List<Tag> _tags = [];

  List<Tag> get tags => _tags;

  Future<void> loadTags() async {
    _tags = await DatabaseHelper().getTags();
    notifyListeners();
  }

  Future<void> addTag(Tag tag) async {
    await DatabaseHelper().insertTag(tag);
    //print(tag.toMap());
    _tags.add(tag);
    loadTags();
    notifyListeners();
  }

  Future<void> updateTag(Tag tag) async {
    await DatabaseHelper().updateTag(tag);
    int index = _tags.indexWhere((c) => c.id == tag.id);
    if (index != -1) {
      _tags[index] = tag;
      loadTags();
      notifyListeners();
    }
  }

  Future<void> deleteTag(int id) async {
    await DatabaseHelper().deleteTag(id);
    _tags.removeWhere((c) => c.id == id);
    loadTags();
    notifyListeners();
  }
}
