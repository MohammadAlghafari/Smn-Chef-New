
import 'package:flutter/material.dart';
import 'package:smn_admin/data/order/model/statistic.dart';
import 'package:smn_admin/view/customWidget/statistics_widgets/statistics_carousel_loader_widget.dart';
import 'package:smn_admin/view/customWidget/statistics_widgets/statistic_carousel_item_widget.dart';

class StatisticsCarouselWidget extends StatelessWidget {
  final List<Statistic> statisticsList;

  StatisticsCarouselWidget({Key? key, required this.statisticsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statisticsList.isEmpty
        ? StatisticsCarouselLoaderWidget()
        : Container(
        height: 190,
        color: Theme.of(context).primaryColor.withOpacity(0.7),
//            padding: EdgeInsets.symmetric(vertical: 30),
        child: ListView.builder(
          itemCount: statisticsList.length,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            return StatisticCarouselItemWidget(
              marginLeft: _marginLeft,
              statistic: statisticsList.elementAt(index),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }
}
