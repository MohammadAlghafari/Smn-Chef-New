import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CardWidget extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;
  late AppLocalizations _trans;

  CardWidget({Key? key, required this.restaurant, required this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Container(
      width: 292,
      margin: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Hero(
                tag: heroTag + restaurant.id,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: restaurant.image.url!,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color: restaurant.closed ? Colors.grey : Colors.green,
                        borderRadius: BorderRadius.circular(24)),
                    child: restaurant.closed
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                        color: restaurant.availableForDelivery
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(24)),
                    child:
                        /* Text(
                      S.of(context).delivery,
                      style: Theme.of(context).textTheme.caption.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    ), */
                        restaurant.availableForDelivery
                            ? Text(
                                _trans.delivery,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .merge(TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              )
                            : Text(
                                _trans.pickup,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .merge(TextStyle(
                                        color: Theme.of(context).primaryColor)),
                              ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        restaurant.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        Helper.skipHtml(restaurant.description),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children:
                            Helper.getStarsList(double.parse(restaurant.rate)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
