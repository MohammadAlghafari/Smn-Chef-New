import 'package:flutter/material.dart';
import 'package:smn_admin/data/order/model/review.dart';
import 'package:smn_admin/view/customWidget/review/review_item_widget.dart';

import '../Circular_loading_widget.dart';


// ignore: must_be_immutable
class ReviewsListWidget extends StatelessWidget {
  List<Review> reviewsList;

  ReviewsListWidget({Key? key, required this.reviewsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reviewsList.isEmpty
        ? CircularLoadingWidget(height: 200)
        : ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return ReviewItemWidget(review: reviewsList.elementAt(index));
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 20);
      },
      itemCount: reviewsList.length,
      primary: false,
      shrinkWrap: true,
    );
  }
}
