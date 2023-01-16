import 'package:smn_admin/data/faq/faq_interface.dart';
import 'package:smn_admin/data/faq/model/faq_category.dart';

import 'api/faq_api.dart';

class FaqRepo implements FaqInterface{
  FaqApi faqApi;

  FaqRepo({required this.faqApi});
  @override
  Future<List<FaqCategory>> getFaqCategories() {
    return faqApi.getFaqCategories();
  }

}