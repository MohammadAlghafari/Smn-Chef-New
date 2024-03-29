import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

import '../smn_chef.dart';


class App {
  BuildContext? _context;
  double? _height;
  double? _width;
  double? _heightPadding;
  double? _widthPadding;

  App() {
    _context = NavigationService.navigatorKey.currentContext!;
    MediaQueryData _queryData = MediaQuery.of(_context!);
    _height = _queryData.size.height / 100.0;
    _width = _queryData.size.width / 100.0;
    _heightPadding = _height! - ((_queryData.padding.top + _queryData.padding.bottom) / 100.0);
    _widthPadding = _width! - (_queryData.padding.left + _queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height! * v;
  }

  double appWidth(double v) {
    return _width !* v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding !* v;
  }

  double appHorizontalPadding(double v) {
//    int.parse(settingRepo.setting.mainColor.replaceAll("#", "0xFF"));
    return _widthPadding !* v;
  }
}

class Colors {
  BuildContext? _context;
  Colors(context){
    _context=context;
  }

  Color mainColor(double opacity) {
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.mainColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color secondColor(double opacity) {
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.secondColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color accentColor(double opacity) {
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.accentColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color mainDarkColor(double opacity) {
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.mainDarkColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color secondDarkColor(double opacity) {
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.secondDarkColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color accentDarkColor(double opacity) {
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.accentDarkColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  Color scaffoldColor(double opacity) {
    // TODO test if brightness is dark or not
    try {
      return Color(int.parse(Provider.of<SettingViewModel>(this._context!,listen: false).setting.scaffoldColor.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }
}
