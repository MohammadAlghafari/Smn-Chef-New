
class Cuisine {
  String id;
  String name;


  Cuisine({required this.id, required this.name});

  factory Cuisine.fromJSON(Map<String, dynamic> jsonMap) {
    return Cuisine(
      id : jsonMap['id'].toString(),
      name : jsonMap['name'].toString(),

    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
  };


  @override
  bool operator == (dynamic other) {
    return other.id == id;
  }


  @override
  int get hashCode => super.hashCode;
}