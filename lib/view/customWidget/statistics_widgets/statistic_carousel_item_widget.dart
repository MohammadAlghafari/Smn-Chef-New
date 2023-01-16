import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/data/order/model/statistic.dart';
import 'package:smn_admin/utili/helper.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

class StatisticCarouselItemWidget extends StatelessWidget {
  final double marginLeft;
  final Statistic statistic;

  StatisticCarouselItemWidget(
      {Key? key, required this.marginLeft, required this.statistic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
          start: this.marginLeft, end: 20, top: 25, bottom: 25),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2)),
        ],
      ),
      width: 170,
      height: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statistic.description == "total_earning")
            Consumer<SettingViewModel>(
              builder: (context, settingModel, child) {
                return Helper.getPrice(double.tryParse(statistic.value)!,
                    context, settingModel.setting,
                    style: Theme.of(context).textTheme.headline2!.merge(
                      TextStyle(height: 1),
                    ));
              },
            )
          else
            Text(
              statistic.value,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .merge(TextStyle(height: 1)),
            ),
          SizedBox(height: 8),
          Text(
            Helper.trans(statistic.description,context),
            textAlign: TextAlign.center,
            maxLines: 3,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }
}
