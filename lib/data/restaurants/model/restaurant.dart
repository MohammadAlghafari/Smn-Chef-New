import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/models/media.dart';
import 'package:smn_admin/data/order/model/cuisine.dart';

class Restaurant {
  String id;
  String name;
  String nameEn;
  Media image;
  String rate;
  String descriptionArb;
  String nameArb;
  String addressArb;
  String address;
  String description;
  String descriptionEn;
  String phone;
  String mobile;
  String information;
  String deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  bool closed;
  String avgTime;
  bool availableForDelivery;
  double deliveryRange;
  double distance;
  List<User> users;
  List<Cuisine> cuisines;
  String deliveryCities;

  Restaurant(
      {required this.id,
      required this.name,
      required this.image,
      required this.rate,
      required this.address,
      required this.description,
      required this.phone,
      required this.deliveryCities,
      required this.mobile,
      required this.avgTime,
      required this.information,
      required this.deliveryFee,
      required this.adminCommission,
      required this.defaultTax,
      required this.latitude,
      required this.longitude,
      required this.closed,
      required this.availableForDelivery,
      required this.deliveryRange,
      required this.distance,
      required this.descriptionEn,
      required this.nameEn,
      required this.users,
      required this.addressArb,
      required this.cuisines,
      required this.descriptionArb,
      required this.nameArb});

  factory Restaurant.fromJSON(Map<String, dynamic> jsonMap) {
    return Restaurant(
      id: jsonMap['id'].toString(),
      name: jsonMap['name'] ?? "",
      nameEn: jsonMap['name_en'] ?? "",
      descriptionEn: jsonMap['description_en'] ?? "",
      image: jsonMap['media'] != null && (jsonMap['media'] as List).isNotEmpty
          ? Media.fromJSON(jsonMap['media'][0])
          : Media.fromJSON({}),
      rate: jsonMap['rate'] ?? '0',
      // deliveryFee: 0.0,
      deliveryFee: jsonMap['delivery_fee'] ?? '',
      adminCommission: jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0,
      deliveryRange: jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0,
      address: jsonMap['address'] ?? "",
      description: jsonMap['description'] ?? "",
      phone: jsonMap['phone'] ?? "",
      mobile: jsonMap['mobile'] ?? "",
      defaultTax: jsonMap['default_tax'] != null
          ? jsonMap['default_tax'].toDouble()
          : 0.0,
      avgTime: jsonMap['avg_time'] ?? '',
      information: jsonMap['information'] ?? "",
      latitude: jsonMap['latitude'] ?? "33.33",
      longitude: jsonMap['longitude'] ?? "33.33",
      closed: jsonMap['closed'] ?? false,
      addressArb: jsonMap['arb_address'] ?? '',
      descriptionArb: jsonMap['description_arb'] ?? '',
      nameArb: jsonMap['name_arb'] ?? '',
      availableForDelivery: jsonMap['available_for_delivery'] ?? false,
      distance: jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0.0,
      users: jsonMap['users'] != null && (jsonMap['users'] as List).isNotEmpty
          ? List.from(jsonMap['users'])
              .map((element) => User.fromJSON(element))
              .toSet()
              .toList()
          : [],
      cuisines:
          jsonMap['cuisines'] != null && (jsonMap['cuisines'] as List).isNotEmpty
              ? List.from(jsonMap['cuisines'])
                  .map((element) => Cuisine.fromJSON(element))
                  .toSet()
                  .toList()
              : [],
        deliveryCities:jsonMap['delivery_cities']??'',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }


}
