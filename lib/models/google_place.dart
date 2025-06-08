class GooglePlace {
  final String? id;
  final String name;
  final double? lat;
  final double? lng;
  final String? address;

  GooglePlace({
    this.id,
    required this.name,
    this.lat,
    this.lng,
    this.address,
  });

  factory GooglePlace.fromJson(Map<String, dynamic> json) {
    return GooglePlace(
      id: json['id'] ?? json['place_id'],
      name: json['displayName']?['text'] ?? json['name'] ?? '-',
      lat: json['location']?['latitude'],
      lng: json['location']?['longitude'],
      address: json['formattedAddress'] ?? json['vicinity'] ?? '',
    );
  }
}