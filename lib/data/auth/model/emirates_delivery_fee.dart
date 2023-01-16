import 'package:flutter/cupertino.dart';

class EmiratesDeliveryFee {
  String emirateName;

  // String deliveryFee;
  FocusNode focusNode= FocusNode();
  bool isEnable;
  String englishName;
  final TextEditingController deliveryFee = TextEditingController();

  EmiratesDeliveryFee({required this.emirateName, required this.isEnable,required this.englishName});

  factory EmiratesDeliveryFee.fromJSON(Map<String, dynamic> jsonMap) {
    return EmiratesDeliveryFee(
      emirateName: jsonMap['emirateName'] ?? '',
      englishName: jsonMap['englishName'] ?? '',
      isEnable: jsonMap['isEnable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'delivery_cities': emirateName,
        'delivery_fee': deliveryFee.text,
      };


}
