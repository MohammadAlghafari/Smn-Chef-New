import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smn_admin/data/faq/fac_repo.dart';
import 'package:smn_admin/data/faq/model/faq_category.dart';

class FaqViewModel extends ChangeNotifier {
  bool loadingData = true;
  List<FaqCategory> faqs = <FaqCategory>[];
  FaqRepo faqRepo;

  FaqViewModel({required this.faqRepo}) {
    listenForFaqs();
  }

  void listenForFaqs({String? message}) async {
    loadingData = true;
    faqs = await faqRepo.getFaqCategories();
    loadingData = false;
    notifyListeners();
  }

  Future<void> refreshFaqs() async {
    faqs.clear();
    listenForFaqs(message: 'Faqs refreshed successfuly');
  }
}
