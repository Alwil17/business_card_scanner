import 'package:business_card_scanner/models/tag.dart';

class BusinessCard {
  int? id;
  String name;
  String? position;
  String? companyName;
  List<String> emails;
  List<String> phoneNumbers;
  String? website;
  String? address;
  String imagePath;
  String? note;
  List<Tag> tags;

  BusinessCard({
    this.id,
    required this.name,
    this.position,
    this.companyName,
    required this.emails,
    required this.phoneNumbers,
    this.website,
    this.address,
    required this.imagePath,
    this.note,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'companyName': companyName,
      'emails': emails.join(','), // Store as comma-separated string
      'phoneNumbers': phoneNumbers.join(','), // Store as comma-separated string
      'website': website,
      'address': address,
      'imagePath': imagePath,
      'note': note
    };
  }

  // Méthode pour créer un BusinessCard à partir d'une Map
  static Future<BusinessCard> fromMap(Map<String, dynamic> map, List<Tag> allTags) async {
    // Récupérer les tags depuis la liste globale à partir des IDs stockés
    //List<String> tagIds = map['tags'] != null ? map['tags'].split(',') : [];


    return BusinessCard(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      companyName: map['companyName'],
      emails: (map['emails'] as String).split(','),
      phoneNumbers: (map['phoneNumbers'] as String).split(','),
      website: map['website'],
      address: map['address'],
      imagePath: map['imagePath'],
      note: map['note'],
      tags: allTags,
    );
  }
}
