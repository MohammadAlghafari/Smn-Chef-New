import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/data/messages/model/conversation.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/screens/messages/widget/empty_messages_widget.dart';
import 'package:smn_admin/view/screens/messages/widget/message_item_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:smn_admin/view_models/messages_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<MessagesViewModel>(context,listen: false).listenForConversations();
    super.initState();
  }

  Widget conversationsList(MessagesViewModel messagesViewModel) {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesViewModel.conversations,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var _docs = messagesViewModel.orderSnapshotByTime(snapshot);
          return ListView.separated(
              itemCount: _docs.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                Conversation _conversation =
                Conversation.fromJSON(_docs[index].data());
                return MessageItemWidget(
                  message: _conversation,
                  onDismissed: (conversation) async {
                    setState(() {
                      _docs.removeAt(index);
                    });
                    await messagesViewModel.removeConversation(conversation.id!);
                  },
                );
              });
        } else {
          return EmptyMessagesWidget();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return Scaffold(
        key: scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.menu,
          icon:  Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.messages,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
           Tooltip(
             message: _trans.notifications,
             child: NotificationButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).colorScheme.secondary),
           ),
        ],
      ),
      body: Consumer<MessagesViewModel>(builder: (context, messagesModel, child) {

        if(messagesModel.loadingConversations) {
          return CircularLoadingWidget(height: 500);
        }
        return ListView(
          primary: false,
          children: <Widget>[
            conversationsList(messagesModel),
          ],
        );
      },),
    );
  }
}
