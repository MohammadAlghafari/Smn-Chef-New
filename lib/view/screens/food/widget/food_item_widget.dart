import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

class FoodItemWidget extends StatelessWidget {
  final String heroTag;
  final Food food;
  late AppLocalizations _trans;

  FoodItemWidget({Key? key, required this.food, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Stack(
      children: [
        InkWell(
          splashColor: Theme.of(context).accentColor,
          focusColor: Theme.of(context).accentColor,
          highlightColor: Theme.of(context).primaryColor,
          onTap: () {
            // Navigator.of(context).pushNamed('/Food', arguments: RouteArgument(id: food.id, heroTag: this.heroTag));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: heroTag + food.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: food.image.thumb!,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              food.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Row(
                              children: Helper.getStarsList(food.getRate()),
                            ),
                            Text(
                              food.extras
                                  .map((e) => e.name)
                                  .toList()
                                  .join(', '),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Consumer<SettingViewModel>(
                        builder: (context, settingModel, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              food.discountPrice > 0
                                  ? Helper.getPrice(
                                      food.discountPrice,
                                      context,
                                      settingModel.setting,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    )
                                  : const SizedBox(height: 0),
                              Helper.getPrice(
                                  food.price, context, settingModel.setting,
                                  style: food.discountPrice > 0
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .merge(const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough))
                                      : Theme.of(context).textTheme.headline4),

                              // food.discountPrice > 0
                              //     ? Helper.getPrice(food.discountPrice, context,
                              //         settingModel.setting,
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .bodyText2!
                              //             .merge(const TextStyle(
                              //                 decoration:
                              //                     TextDecoration.lineThrough)))
                              //     : const SizedBox(height: 0),
                              // Text(
                              //   food.active ? _trans.active : _trans.pending,
                              //   overflow: TextOverflow.ellipsis,
                              //   maxLines: 2,
                              //   style: TextStyle(
                              //       color:
                              //           food.active ? Colors.green :Colors.orange),
                              // ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, 'EditFoodScreen',
                                          arguments: food);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Text(
                                        _trans.edit,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  const Text('|'),
                                  InkWell(
                                    onTap: () {
                                      showAlertDialog(context);
                                    },
                                    child: Padding(
                                      padding: isRTL
                                          ? const EdgeInsets.only(
                                              right: 8, top: 4, bottom: 4)
                                          : const EdgeInsets.only(
                                              left: 8, top: 4, bottom: 4),
                                      child: Text(
                                        _trans.delete,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  /*  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: FlatButton(
                                      padding: const EdgeInsets.all(0),
                                      color: Colors.red,
                                      onPressed: () {
                                        showAlertDialog(context);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      shape: const StadiumBorder(),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, 'EditFoodScreen',
                                            arguments: food);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color:
                                            Theme.of(context).colorScheme.secondary,
                                      )), */
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          child: Icon(Icons.circle,
              size: 40, color: food.active ? Colors.green : Colors.red),
          top: -17,
          right: -18,
        )
      ],
    );
  }

  showAlertDialog(
    BuildContext context,
  ) {
    Widget okButton = TextButton(
      child: Text(
        _trans.yes,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        buildShowDialog(context);
        Provider.of<RestaurantsViewModel>(context, listen: false)
            .deleteFood(foodId: food.id);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        _trans.alert,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      content: Text(_trans.are_you_sure_you_want_to_delete_this_food,
          ),
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
