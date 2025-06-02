class Plant {
  final String name;
  final int minMoisture;
  final int maxMoisture;
  final String imageUrl;

  Plant({
    required this.name,
    required this.minMoisture,
    required this.maxMoisture,
    required this.imageUrl,
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      name: map['name'] ?? 'Unknown',
      minMoisture: map['minMoisture'] ?? 0,
      maxMoisture: map['maxMoisture'] ?? 1000,
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  factory Plant.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) throw ArgumentError("Null plant data from Firestore");
    return Plant.fromMap(data);
  }
}
