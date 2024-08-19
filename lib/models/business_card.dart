class BusinessCard {
  final int? id;
  final String name;
  final String? position;
  final String? companyName;
  final List<String> emails;
  final List<String> phoneNumbers;
  final String? website;
  final String? address;
  final String imagePath;

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
      website: map['website'],
      address: map['address'],
      imagePath: map['imagePath'],
    );
  }
}
