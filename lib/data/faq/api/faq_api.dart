import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:smn_admin/const/url.dart' as url;
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/data/auth/model/user.dart';
import 'package:smn_admin/data/faq/model/faq_category.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';

import '../../../smn_chef.dart';


class FaqApi {
  Dio dio;

  AuthViewModel authViewModel;

  FaqApi({required this.authViewModel, required this.dio});

  Future<List<FaqCategory>> getFaqCategories() async {
    try {
      if( authViewModel.user==null )return[];
      User _user = authViewModel.user!;
      final String _apiToken = 'api_token=${_user.apiToken}&';
      final response = await dio.get(url.getFaqCategories(_apiToken));
      return (response.data['data'] as List)
          .map<FaqCategory>((json) => FaqCategory.fromJSON(json))
          .toList();
    }catch (e) {
      final response = e as DioError;
      showSnackBar(message: (response.response!.data['message']));
      return [];
    }
  }
}
