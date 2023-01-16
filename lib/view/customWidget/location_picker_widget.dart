import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationPickerWidget extends StatefulWidget {
  Function onUpdateAddress;
   LocationPickerWidget({Key? key,required this.onUpdateAddress}) : super(key: key);

  @override
  _LocationPickerWidgetState createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  LocationResult? result;
  late GoogleMapController _controller;
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        children: [
          Divider(),
          Row(
            children: [
              Text(_trans.address),
            ],
          ),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              showPlacePicker();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                height: config.App().appHeight(17),
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(33.33, 33.33),
                        zoom: 14.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      zoomControlsEnabled: false,
                    ),
                    Container(
                      child: Center(),
                      color: Color(0xFF0E3311).withOpacity(0.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPlacePicker() async {
    result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PlacePicker(
                "AIzaSyD_lRvTskGkN80rrp59iaaMPyG8SmzZRQE",
              )),
    );
    if(result!=null&&result!.latLng!=null) {
      _controller.moveCamera(CameraUpdate.newLatLng(result!.latLng!));
      widget.onUpdateAddress(result);
    }

  }
}
