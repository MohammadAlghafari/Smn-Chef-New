class Payment {
  String? id;
  String? status;
  String? method;
  double? price;

  Payment(this.method, {this.id, this.status, this.price});

  factory Payment.fromJSON(Map<String, dynamic> jsonMap) {
    return Payment(jsonMap['method'],
        id: jsonMap['id'].toString(), status: jsonMap['status'] ?? '', price: double.parse(jsonMap['price'].toString()) );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
      'price': price,
    };
  }
}
