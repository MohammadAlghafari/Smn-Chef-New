import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';


class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late AppLocalizations _trans;

  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantsViewModel>(NavigationService.navigatorKey.currentContext!, listen: false).mapController =
        Completer();
    if (Provider.of<RestaurantsViewModel>(context, listen: false)
        .restaurant
        ?.latitude !=
        null) {
      // user select a restaurant
      Provider.of<RestaurantsViewModel>(context, listen: false)
          .getRestaurantLocation();
      //_con.getDirectionSteps();
    } else {
      Provider.of<RestaurantsViewModel>(context, listen: false)
          .goCurrentLocation();
      Provider.of<RestaurantsViewModel>(context, listen: false)
          .getCurrentLocation();
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) {

    });
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Theme.of(context).hintColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _trans.restaurant_location,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              Provider.of<RestaurantsViewModel>(context, listen: false)
                  .goCurrentLocation();
              Provider.of<RestaurantsViewModel>(context, listen: false)
                  .getCurrentLocation();
              Provider.of<RestaurantsViewModel>(context, listen: false)
                  .notify();
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          Consumer<RestaurantsViewModel>(
            builder: (context, restaurantModel, child) {
              return restaurantModel.cameraPosition == null
                  ? CircularLoadingWidget(height: 200)
                  : GoogleMap(
                      mapToolbarEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: restaurantModel.cameraPosition!,
                      markers: Set.from(restaurantModel.allMarkers),
                      onMapCreated: (GoogleMapController controller) {
                        if (!restaurantModel.mapController.isCompleted) {
                          restaurantModel.mapController.complete(controller);
                        }
                      },
                      onCameraMove: (CameraPosition cameraPosition) {
                        restaurantModel.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () {},
                    );
            },
          )
        ],
      ),
    );
  }


}
