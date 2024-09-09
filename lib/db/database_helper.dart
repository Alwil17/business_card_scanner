import 'package:business_card_scanner/models/business_card.dart';
import 'package:business_card_scanner/models/tag.dart';
import 'package:business_card_scanner/models/tag.dart';
import 'package:business_card_scanner/models/tag.dart';
import 'package:business_card_scanner/models/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'business_cards.db');
    // Delete the database
    //await deleteDatabase(path);
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        // Create cards table
        await db.execute(
          '''
          CREATE TABLE cards(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          position TEXT,
          companyName TEXT,
          emails TEXT NOT NULL,
          phoneNumbers TEXT NOT NULL,
          website TEXT,
          address TEXT,
          imagePath TEXT NOT NULL,
          note TEXT
        ) ''',
        );
        // Create tags table
        await db.execute(
          '''
          CREATE TABLE tags(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
          ''',
        );
        // Create card_tags table
        await db.execute(
          '''
          CREATE TABLE card_tags(
          card_id INTEGER,
          tag_id INTEGER,
          FOREIGN KEY(card_id) REFERENCES cards(id) ON DELETE CASCADE,
          FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE CASCADE
        )
          ''',
        );
      },
      version: 2,
    );
  }

  // cards
  Future<List<BusinessCard>> getCards() async {
    final Database db = await database;
    final List<Map<String, dynamic>> cardMaps = await db.query('cards');
    final List<Tag> allTags = await getTags();  // Récupère tous les tags disponibles

    List<BusinessCard> cards = [];

    for (var cardMap in cardMaps) {
      // Récupère les relations entre la carte et les tags
      final List<Map<String, dynamic>> cardTagMaps = await db.query(
        'card_tags',
        where: 'card_id = ?',
        whereArgs: [cardMap['id']],
      );

      // Trouver les tags correspondants à partir des IDs
      List<Tag> cardTags = [];
      for (var cardTagMap in cardTagMaps) {
        final tag = allTags.firstWhere((tag) => tag.id == cardTagMap['tag_id']);
        cardTags.add(tag);
      }
      // Crée la carte avec les tags
      final card = await BusinessCard.fromMap(cardMap, cardTags);
      cards.add(card);
    }

    return cards;
  }

  Future<void> insertCard(BusinessCard card) async {
    final Database db = await database;
    // Insertion de la carte
    int cardId = await db.insert(
      'cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insertion des relations card_tags
    for (var tag in card.tags) {
      await db.insert(
        'card_tags',
        {
          'card_id': cardId,
          'tag_id': tag.id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> updateCard(BusinessCard card) async {
    final Database db = await database;

    // Mise à jour des informations de la carte
    await db.update(
      'cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );

    // Suppression des anciennes relations card_tags
    await db.delete(
      'card_tags',
      where: 'card_id = ?',
      whereArgs: [card.id],
    );

    // Insertion des nouvelles relations card_tags
    for (var tag in card.tags) {
      await db.insert(
        'card_tags',
        {
          'card_id': card.id,
          'tag_id': tag.id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteCard(int id) async {
    final Database db = await database;
    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // tags
  Future<List<Tag>> getTags() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tags');

    return List.generate(maps.length, (i) {
      return Tag.fromMap(maps[i]);
    });
  }

  Future<void> insertTag(Tag tag) async {
    final Database db = await database;
    print(tag.toMap());
    await db.insert(
      'tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTag(Tag tag) async {
    final Database db = await database;
    await db.update(
      'tags',
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<void> deleteTag(int id) async {
    final Database db = await database;
    await db.delete(
      'tags',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
