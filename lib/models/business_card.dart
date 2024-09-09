class BusinessCard {
  int? id;
  String name;
  String? position;
  String? companyName;
  List<String> emails;
  List<String> phoneNumbers;
  List<String>? tags;
  String? website;
  String? address;
  String imagePath;
  String? note;

  BusinessCard({
    this.id,
    required this.name,
    this.position,
    this.companyName,
    required this.emails,
    required this.phoneNumbers,
    this.tags,
    this.website,
    this.address,
    required this.imagePath,
    this.note
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'companyName': companyName,
      'emails': emails.join(','), // Store as comma-separated string
      'tags': (tags != null && tags!.isNotEmpty) ? tags!.join(',') : null, // Store as comma-separated string
      'phoneNumbers': phoneNumbers.join(','), // Store as comma-separated string
      'website': website,
      'address': address,
      'imagePath': imagePath,
      'note': note
    };
  }

  static BusinessCard fromMap(Map<String, dynamic> map) {
    return BusinessCard(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      companyName: map['companyName'],
      emails: map['emails'].split(','), // Convert comma-separated string to list
      phoneNumbers: map['phoneNumbers'].split(','), // Convert comma-separated string to list
      tags: (map['tags'] != null) ? map['tags'].split(',') : null, // Convert comma-separated string to list
      website: map['website'],
      address: map['address'],
      imagePath: map['imagePath'],
      note: map['note']
    );
  }
}
