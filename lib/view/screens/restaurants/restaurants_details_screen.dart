import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/myColors.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view/customWidget/drawer_widget.dart';
import 'package:smn_admin/view/customWidget/image_thumb_carousel_widget.dart';
import 'package:smn_admin/view/customWidget/review/reviews_list_widget.dart';
import 'package:smn_admin/view/screens/food/widget/food_item_widget.dart';
import 'package:smn_admin/view/screens/notifications/widget/notification_button_widget.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';

class RestaurantsDetailsScreen extends StatefulWidget {
  final String id;
  String? heroTag;

  RestaurantsDetailsScreen({Key? key, required this.id, this.heroTag})
      : super(key: key);

  @override
  _RestaurantsDetailsScreenState createState() =>
      _RestaurantsDetailsScreenState();
}

class _RestaurantsDetailsScreenState extends State<RestaurantsDetailsScreen> {
  late AppLocalizations _trans;

  @override
  void initState() {
    Provider.of<RestaurantsViewModel>(context, listen: false).init(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Consumer<RestaurantsViewModel>(
          builder: (context, restaurantsModel, child) {
            return RefreshIndicator(
              onRefresh: restaurantsModel.refreshRestaurant,
              child: restaurantsModel.isLoadingRestaurant()
                  ? CircularLoadingWidget(height: 500)
                  : getRestaurantWidget(restaurantsModel),
            );
          },
        ));
  }

  getRestaurantWidget(RestaurantsViewModel restaurantsModel) {
    if (restaurantsModel.restaurant!.id == 'null') {
      return Scaffold(
        //drawer: const DrawerWidget(),
        body: Center(
          child:CircularLoadingWidget(height: 500,)
          
           /* Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/Error.png',
                width: 200,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                _trans.oops_Check_your_internet_connection,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 40,
              ),
              IconButton(
                  onPressed: () {
                    Provider.of<RestaurantsViewModel>(context, listen: false)
                        .init(widget.id);
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).hintColor,
                    size: 35,
                  ))
            ],
          ), */
        ),
      );
    }
    return CustomScrollView(
      primary: true,
      shrinkWrap: false,
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
          expandedHeight: 300,
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: _trans.back,
            icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  bool isRTL = Directionality.of(context) == TextDirection.rtl;
                  showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          isRTL ? 0 : 1, 1, isRTL ? 1 : 0, 0),
                      items: [
                        PopupMenuItem(
                          child: Text(_trans.edit_your_kitchen),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(
                                context, 'EditRestaurantFirstScreen',
                                arguments: restaurantsModel.restaurant!);
                            Navigator.pushNamed(
                                context, 'EditRestaurantFirstScreen',
                                arguments: restaurantsModel.restaurant!);
                          },
                        ),
                        PopupMenuItem(
                          child: Text(restaurantsModel.restaurant!.closed
                              ? _trans.open_your_kitchen
                              : _trans.close_your_kitchen),
                          onTap: () {
                            Navigator.of(context).pop();
                            showAlertDialog(
                                context, restaurantsModel.restaurant!);
                            showAlertDialog(
                                context, restaurantsModel.restaurant!);
                          },
                        )
                      ]);
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ))
          ],
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Hero(
              tag: (Random().nextInt(1111)).toString() +
                  // tag: (widget.heroTag ?? '') +
                  restaurantsModel.restaurant!.id,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: restaurantsModel.restaurant!.image.url!,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 10, top: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        restaurantsModel.restaurant!.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                      child: Chip(
                        padding: const EdgeInsets.all(0),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(restaurantsModel.restaurant!.rate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        color:
                                            Theme.of(context).primaryColor))),
                            Icon(
                              Icons.star_border,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.9),
                        shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color: restaurantsModel.restaurant!.closed
                            ? Colors.grey
                            : Colors.green,
                        borderRadius: BorderRadius.circular(24)),
                    child: restaurantsModel.restaurant!.closed
                        ? Text(
                            _trans.closed,
                            style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        : Text(
                            _trans.open,
                            style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color: restaurantsModel.restaurant!.availableForDelivery
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(24)),
                    child: restaurantsModel.restaurant!.availableForDelivery
                        ? Text(
                            _trans.delivery,
                            style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )
                        : Text(
                            _trans.pickup,
                            style: Theme.of(context).textTheme.caption!.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                  ),
                  /*  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        _trans.edit_your_kitchen,
                        style: Theme.of(context).textTheme.caption!.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ), */
                ],
              ),
              /* Align(
                alignment: AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context, restaurantsModel.restaurant!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          restaurantsModel.restaurant!.closed
                              ? _trans.open_your_kitchen
                              : _trans.close_your_kitchen,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.door_back_door),
                      ],
                    ),
                  ),
                ),
              ), */
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Helper.applyHtml(
                    context, restaurantsModel.restaurant!.description),
              ),
              ImageThumbCarouselWidget(
                  galleriesList: restaurantsModel.galleries),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Theme.of(context).primaryColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        restaurantsModel.restaurant!.address,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: FlatButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.of(context).pushNamed('MapWidget');
                        },
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        color: Theme.of(context).accentColor.withOpacity(0.9),
                        shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.shopping_basket,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _trans.foods,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: restaurantsModel.foods.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return FoodItemWidget(
                    heroTag: 'details_food',
                    food: restaurantsModel.foods.elementAt(index),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'CreateFoodScreen');
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'CreateFoodScreen');
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Image.asset(
                              'assets/img/plus_icon.png',
                              height: config.App().appHeight(4),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            shape: const CircleBorder(),
                          ),
                          // ElevatedButton(
                          //   style: ButtonStyle(
                          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(18.0),
                          //
                          //         ),
                          //       ),
                          //       backgroundColor: MaterialStateProperty.all<Color>(myColors.deepOrange)),
                          //   onPressed: () {
                          //     Navigator.pushNamed(context, 'CreateFoodScreen');
                          //   },
                          //   child: Text(_trans.add_new_food),
                          // )
                        ],
                      ),
                      Text(
                        _trans.add_new_food,
                        style: TextStyle(color: myColors.deepOrange),
                      )
                    ],
                  ),
                ),
              ),
              restaurantsModel.featuredFoods.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.shopping_basket,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          _trans.featuredFoods,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
              restaurantsModel.featuredFoods.isEmpty
                  ? Container()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: restaurantsModel.featuredFoods.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return FoodItemWidget(
                          heroTag: 'details_featured_food',
                          food: restaurantsModel.featuredFoods.elementAt(index),
                        );
                      },
                    ),
              const SizedBox(height: 100),
              restaurantsModel.reviews.isEmpty
                  ? const SizedBox(height: 5)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.recent_actors,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          _trans.whatTheySay,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ),
              restaurantsModel.reviews.isEmpty
                  ? const SizedBox(height: 5)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ReviewsListWidget(
                          reviewsList: restaurantsModel.reviews),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, Restaurant restaurant) {
    Widget okButton = TextButton(
      child: Text(
        _trans.yes,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        buildShowDialog(context);
        Provider.of<RestaurantsViewModel>(context, listen: false)
            .setCloseRestaurant(restaurant.id, !restaurant.closed);
      },
    );
    Widget noButton = TextButton(
      child: Text(
        _trans.no,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      title: Text(
        _trans.alert,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      content: Text(
          restaurant.closed
              ? _trans.are_you_sure_you_want_to_open_your_kitchen
              : _trans.are_you_sure_you_want_to_close_your_kitchen,
          textAlign: TextAlign.center),
      actions: [
        noButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
