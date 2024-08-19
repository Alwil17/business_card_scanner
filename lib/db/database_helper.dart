import 'package:business_card_scanner/models/business_card.dart';
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
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
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
            imagePath TEXT NOT NULL
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<List<BusinessCard>> getCards() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cards');

    return List.generate(maps.length, (i) {
      return BusinessCard.fromMap(maps[i]);
    });
  }

  Future<void> insertCard(BusinessCard card) async {
    final Database db = await database;
    await db.insert(
      'cards',
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCard(BusinessCard card) async {
    final Database db = await database;
    await db.update(
      'cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> deleteCard(int id) async {
    final Database db = await database;
    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
