import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/messages/model/chat.dart';
import 'package:smn_admin/data/setting/model/setting.dart';

class ChatMessageListItem extends StatelessWidget {
  final Chat chat;
  final User user;
  final Setting setting;

  ChatMessageListItem(
      {required this.chat, required this.user, required this.setting});

  @override
  Widget build(BuildContext context) {

    return user.id == chat.userId
        ? getSentMessageLayout(context)
        : getReceivedMessageLayout(context);
  }

  Widget getSentMessageLayout(context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.2),
            borderRadius: setting.mobileLanguage.languageCode == 'en'
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(this.chat.user.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .merge(TextStyle(fontWeight: FontWeight.w600))),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(chat.text),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: setting.mobileLanguage.languageCode == 'en' ? 8.0 : 0,
                  right: setting.mobileLanguage.languageCode == 'en' ? 0 : 8.0),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: chat.user.image.thumb!,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReceivedMessageLayout(context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: setting.mobileLanguage.languageCode == 'en'
                ? BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(
                  right: setting.mobileLanguage.languageCode == 'en' ? 8.0 : 0,
                  left: setting.mobileLanguage.languageCode == 'en' ? 0 : 8.0),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: chat.user.image.thumb!,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(this.chat.user.name,
                      style: Theme.of(context).textTheme.bodyText1!.merge(
                          TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor))),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(
                      chat.text,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
