import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/view/screens/restaurants/widget/card_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/screens/restaurants/widget/empty_restaurants_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<RestaurantsViewModel>(context, listen: false)
        .listenForRestaurants();
    super.initState();
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
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.myRestaurants,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          Tooltip(
            message: _trans.notifications,
            child: NotificationButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ),
        ],
      ),
      body: Consumer<RestaurantsViewModel>(
        builder: (context, restaurantsModel, child) {
          return RefreshIndicator(
            onRefresh: restaurantsModel.refreshRestaurants,
            child: restaurantsModel.loadingDataRestaurants ||
                    restaurantsModel.restaurants.isEmpty
                ? EmptyRestaurantsWidget()
                : ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    // physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: restaurantsModel.restaurants.length + 1,
                    itemBuilder: (context, index) {
                      if (index == restaurantsModel.restaurants.length) {
                        return SizedBox(
                          height:
                              restaurantsModel.restaurants.length > 2 ? 0 : 400,
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              'RestaurantsDetailsScreen',
                              arguments: {
                                "id": restaurantsModel.restaurants
                                    .elementAt(index)
                                    .id,
                                "heroTag": 'my_restaurants',
                              });
                        },
                        child: CardWidget(
                            restaurant:
                                restaurantsModel.restaurants.elementAt(index),
                            heroTag: 'my_restaurants'),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
