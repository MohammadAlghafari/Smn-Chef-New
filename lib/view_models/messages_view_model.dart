import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/messages/messages_repo.dart';
import 'package:smn_admin/data/messages/model/chat.dart';
import 'package:smn_admin/data/messages/model/conversation.dart';
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/notifications_view_model.dart';

class MessagesViewModel extends ChangeNotifier {
  MessagesRepo messagesRepo;
  AuthViewModel authViewModel;
  NotificationsViewModel notificationsViewModel;
  Conversation? conversation;
  late Stream<QuerySnapshot> conversations;
  Stream<QuerySnapshot> ?chats;
  bool loadingConversations = true;
  bool loadingConversation = true;
  bool loadingChats = true;

  MessagesViewModel(
      {required this.messagesRepo,
      required this.authViewModel,
      required this.notificationsViewModel});

  listenForConversations() async {
    loadingConversations = true;
    messagesRepo
        .getUserConversations(authViewModel.user!.id!)
        .then((snapshots) {
      conversations = snapshots;
      loadingConversations = false;
      notifyListeners();
    });
  }

  orderSnapshotByTime(AsyncSnapshot snapshot) {
    final docs = snapshot.data.docs;
    docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
      var time1 = a.get('time');
      var time2 = b.get('time');
      return time2.compareTo(time1) as int;
    });
    return docs;
  }

  Future<void> removeConversation(
    String conversationId,
  ) async {
    return await messagesRepo.removeConversation(conversationId);
  }

  listenForChats(Conversation _conversation) async {
    loadingChats = true;
    _conversation.readByUsers!.add(authViewModel.user!.id!);
    messagesRepo.getChats(_conversation).then((snapshots) {
      chats = snapshots;
      loadingChats = false;
      notifyListeners();
    });
  }

  addMessage(Conversation _conversation, String text, int len,
      String restaurantId) async {
    Chat _chat = Chat(
        text: text,
        time: DateTime.now().toUtc().millisecondsSinceEpoch,
        userId: authViewModel.user!.id,
        user:  authViewModel.user!);
    if (_conversation.id == null||_conversation.id!.isEmpty) {
      _conversation.id = UniqueKey().toString();
      _conversation.lastMessage = text;
      _conversation.lastMessageTime = _chat.time;
      _conversation.readByUsers = [authViewModel.user!.id!];
      await createConversation(_conversation);
    } else {
      _conversation.lastMessage = text;
      _conversation.lastMessageTime = _chat.time;
      _conversation.readByUsers = [authViewModel.user!.id!];
    }
    await messagesRepo.addMessage(_conversation, _chat).then((value) async {
      for (var i = 0; i < _conversation.users!.length; i++) {
        if (_conversation.users![i].id != authViewModel.user!.id) {
          /// set data of message on php host
          if (len == 0 || len == null) {
            print("not chat found");
            await messagesRepo.setChatInfo(restaurantId,
                "${_conversation.users![i].id}", "${_conversation.id}");
          }
          await messagesRepo.setChatMessageInfo(text, restaurantId,
              _conversation.id!, authViewModel.user!.id.toString(), "0");
          /* notificationsViewModel.sendNotification(
              text,
              AppLocalizations.of(
                          NavigationService.navigatorKey.currentContext!)!
                      .newMessageFrom +
                  " " +
                  authViewModel.user!.name,
              _conversation.users![i]); */
          break;
        }
      }
    });
  }

  createConversation(Conversation _conversation) async {
    // Conversation _conversation=Conversation.fromJSON({});
    _conversation.id = UniqueKey().toString();
    _conversation.lastMessageTime =
        DateTime.now().toUtc().millisecondsSinceEpoch;
    conversation = _conversation;
    await messagesRepo.createConversation(conversation!).then((value) {
      listenForChats(conversation!);
    });
  }

  Future<String> getConversation(List<String> owners) async {
    return messagesRepo.getConversation(owners);
  }
}
