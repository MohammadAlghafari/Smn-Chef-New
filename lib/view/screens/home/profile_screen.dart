import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/customWidget/profile_avatar_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_admin/view/customWidget/statistics_widgets/statistics_carousel_widget.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/order_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        leading: IconButton(
          tooltip:  _trans.menu,
          icon: Icon(Icons.sort, color: Theme
              .of(context)
              .primaryColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme
            .of(context)
            .colorScheme.secondary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.profile,
          style: Theme
              .of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(
              letterSpacing: 1.3, color: Theme
              .of(context)
              .primaryColor)),
        ),
        actions: <Widget>[
          Tooltip(
            message: _trans.notifications,
            child: NotificationButtonWidget(
                iconColor: Theme
                    .of(context)
                    .primaryColor,
                labelColor: Theme
                    .of(context)
                    .hintColor),
          ),
        ],
      ),
      body: Consumer2<AuthViewModel, OrderViewModel>(
        builder: (context, authModel, orderModel, child) {
          return authModel.user!.apiToken == null
              ? CircularLoadingWidget(height: 500)
              : SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
              children: <Widget>[
                ProfileAvatarWidget(user: authModel.user!),
                StatisticsCarouselWidget(statisticsList: orderModel.statistics),
                ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Icon(
                    Icons.person,
                    color: Theme
                        .of(context)
                        .hintColor,
                  ),
                  title: Text(
                    _trans.about,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    authModel.user!.bio!,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2,
                  ),
                ),
              ],
            ),
          );
        },),
    );
  }
}
