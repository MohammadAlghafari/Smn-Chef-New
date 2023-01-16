import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/const/widgets.dart';
import 'package:smn_admin/view/screens/home/profile_screen.dart';
import 'package:smn_admin/view/screens/messages/messages_screen.dart';
import 'package:smn_admin/view/screens/order/orders_screen.dart';
import 'package:smn_admin/view/screens/restaurants/restaurants_screen.dart';
import 'package:smn_admin/view/screens/settings/settings_screen.dart';
import 'package:smn_admin/view_models/order_view_model.dart';

class HomeScreen extends StatefulWidget {
  final int initialPage;

  const HomeScreen({Key? key, required this.initialPage}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;
  late AppLocalizations _trans;
  late PageController _pageController;

  late int _selectedIndex;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialPage);
    _selectedIndex = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: PageView(
          children: const [
            ProfileScreen(),
            RestaurantScreen(),
            OrdersScreen(),
            MessagesScreen(),
            SettingsScreen(),
          ],
          onPageChanged: (p) {
            setState(() {
              _selectedIndex = p;
            });

            Provider.of<OrderViewModel>(context, listen: false)
                .selectedStatuses = ['0'];
            Provider.of<OrderViewModel>(context, listen: false).selectStatus(
                Provider.of<OrderViewModel>(context, listen: false)
                    .selectedStatuses);
          },
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: _selectedIndex,
          onTap: (int i) {
            _onTappedBar(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              tooltip: _trans.personal_profile,
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store_mall_directory),
              tooltip: _trans.myRestaurants,
              label: '',
            ),
            BottomNavigationBarItem(
                label: '',
                tooltip: _trans.orders,
                icon: Container(
                  width: 42,
                  height: 42,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child:
                      Icon(Icons.home, color: Theme.of(context).primaryColor),
                )),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: '',
              tooltip: _trans.messages,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: '',
              tooltip: _trans.settings,
            ),
          ],
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(message: _trans.tapBackAgainToLeave, context: context);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
