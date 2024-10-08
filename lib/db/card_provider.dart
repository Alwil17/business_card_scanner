import 'package:business_card_scanner/models/business_card.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';


class CardProvider with ChangeNotifier {
  List<BusinessCard> _cards = [];

  List<BusinessCard> get cards => _cards;

  Future<void> loadCards() async {
    _cards = await DatabaseHelper().getCards();
    notifyListeners();
  }

  Future<void> addCard(BusinessCard card) async {
    await DatabaseHelper().insertCard(card);
    //print(card.toMap());
    _cards.add(card);
    loadCards();
    notifyListeners();
  }

  Future<void> updateCard(BusinessCard card) async {
    await DatabaseHelper().updateCard(card);
    int index = _cards.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      _cards[index] = card;
      loadCards();
      notifyListeners();
    }
  }

  Future<void> deleteCard(int id) async {
    await DatabaseHelper().deleteCard(id);
    _cards.removeWhere((c) => c.id == id);
    loadCards();
    notifyListeners();
  }
}
