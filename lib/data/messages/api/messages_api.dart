import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/user.dart' as myUser;
import 'package:smn_admin/data/messages/model/chat.dart';
import 'package:smn_admin/data/messages/model/conversation.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/const/url.dart' as url;

import '../../../smn_chef.dart';

class MessagesApi {
  AuthViewModel authViewModel;
  Dio dio;

  MessagesApi({required this.authViewModel, required this.dio});

  Future<Stream<QuerySnapshot>> getUserConversations(String userId) async {
    return FirebaseFirestore.instance
        .collection("conversations")
        .where('visible_to_users', arrayContains: userId)
        // .orderBy('create_at', descending: true)
        .snapshots();
  }

  Future<void> createConversation(Conversation conversation) async{
    return await FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversation.id)
        .set(conversation.toMap())
        .catchError((e) {
      print(e);
    });
  }

  Future<Stream<QuerySnapshot>> getChats(Conversation conversation) async {
    return updateConversation(
            conversation.id!, {'read_by_users': conversation.readByUsers})
        .then((value) async {
      return  FirebaseFirestore.instance
          .collection("conversations")
          .doc(conversation.id)
          .collection("chats")
          .orderBy('create_at', descending: true)
          .snapshots();
    });
  }

  Future<String> getConversation(List<String> owners) async {
    try {
      String id = await FirebaseFirestore.instance
          .collection("conversations")
          .where(
            'visible_to_users',
            isEqualTo: owners,
          )
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          return value.docs[0].id;
        } else {
          return '';
        }
      });
      return id;
    } on Exception catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return '';
    }
  }

  Future<void> addMessage(Conversation conversation, Chat chat) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversation.id)
        .collection("chats")
        .add(chat.toMap())
        .whenComplete(() {
      updateConversation(conversation.id!, conversation.toUpdatedMap());
    }).catchError((e) {
      showSnackBar(message: (e));
    });
  }

  Future<void> removeConversation(
    String conversationId,
  ) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversationId)
        .delete()
        .catchError((e) {
      showSnackBar(message: (e));
    });
  }

  Future<void> updateConversation(
      String conversationId, Map<String, dynamic> conversation) {
    return FirebaseFirestore.instance
        .collection("conversations")
        .doc(conversationId)
        .update(conversation)
        .catchError((e) {
      showSnackBar(message: (e.toString()));
    });
  }

  Future<bool> setChatInfo(
      String restaurantId, String userId, String conversationId) async {
    myUser.User _user = authViewModel.user!;
    // print(
    //     'api chat sent: https://smnfood.app/api/chat_create?user_id=${_user.id}&conversation_id=${conversation_id.toString()}&restaurant_id=${restaurant_id}&api_token=${_user.apiToken}');
    // var response = await http.post(
    //   Uri.parse('https://smnfood.app/api/chat_create'),
    //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    //   body: jsonEncode(<String, String>{
    //     'restaurant_id': restaurant_id,
    //     'conversation_id': conversation_id,
    //     'user_id': user_id,
    //     'api_token': _user.apiToken!
    //   }),
    // );
    var uri = url.createChat();
    try {
      var response =
          await dio.post(uri, data: {
        'restaurant_id': restaurantId,
        'conversation_id': conversationId,
        'user_id': userId,
        'api_token': _user.apiToken!
      });
      return true;
    } catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return false;
    }
  }

  Future<bool> setChatMessageInfo(String message, String restaurantId,
      String conversationId, String userId, String isCustomer) async {
    myUser.User _user = authViewModel.user!;
     var uri = url.sendChat();
    try {
      var response = await dio.post(uri, data: {
        'conversation_id': conversationId,
        'sender_id': userId,
        'message': message,
        'api_token': _user.apiToken!,
        'is_customer': 0,
      });
      return true;
    } catch (e) {

      // showSnackBar(
      //     message: (AppLocalizations.of(
      //             NavigationService.navigatorKey.currentContext!)!
      //         .verify_your_internet_connection));
      return false;
    }
  }
}
