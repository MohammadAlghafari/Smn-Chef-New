import 'package:location/location.dart';

class Address {
  String id;
  String description;
  String? address;
  double latitude;
  double longitude;
  bool isDefault;
  String userId;

  Address(
      {required this.id,
      this.address,
      required this.description,
      required this.isDefault,
      required this.userId,
      required this.latitude,
      required this.longitude});

  factory Address.fromJSON(Map<String, dynamic> jsonMap) {
    return Address(
        id: jsonMap['id'].toString(),
        description: jsonMap['description'] != null
            ? jsonMap['description'].toString()
            : "",
        address: jsonMap['address'],
        latitude: jsonMap['latitude'] != null
            ? jsonMap['latitude'].toDouble()
            : 33.33,
        longitude: jsonMap['longitude'] != null
            ? jsonMap['longitude'].toDouble()
            : 33.33,
        isDefault: jsonMap['is_default'] ?? false,
        userId: "");
  }

  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    return map;
  }

  LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
