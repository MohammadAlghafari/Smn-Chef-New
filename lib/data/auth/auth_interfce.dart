
import 'package:smn_admin/data/auth/model/user.dart';


abstract class AuthInterface {
  Future<User?> login(String email, String password);

  Future<bool> resetPassword(String email);

  Future<bool> deleteAccount(String apiToken);

  Future<bool> sendOTP(String number);

  Future<bool> verifyOTP(String phone, String code);

  Future<Map<String,dynamic>>  checkExistRestaurant(String userId, String apiToken);
  Future<Map<String, dynamic>> checkRegister(Map<String,dynamic>body);
  Future<User> register(Map<String,dynamic>body);

}
