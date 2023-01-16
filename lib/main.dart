import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_admin/data/messages/model/conversation.dart';
import 'package:smn_admin/data/order/model/food.dart';
import 'package:smn_admin/data/restaurants/model/restaurant.dart';
import 'package:smn_admin/injectionContaner.dart' as di;
import 'package:smn_admin/smn_chef.dart';
import 'package:smn_admin/utili/app_config.dart' as config;
import 'package:smn_admin/utili/notification_service.dart';
import 'package:smn_admin/view/screens/auth/forget_password_screen.dart';
import 'package:smn_admin/view/screens/auth/login_screen.dart';
import 'package:smn_admin/view/screens/auth/signup_screen.dart';
import 'package:smn_admin/view/screens/faq_help/help_screen.dart';
import 'package:smn_admin/view/screens/food/create_food_screen.dart';
import 'package:smn_admin/view/screens/food/edit_food_screen.dart';
import 'package:smn_admin/view/screens/home/home_screen.dart';
import 'package:smn_admin/view/screens/messages/chat_screen.dart';
import 'package:smn_admin/view/screens/notifications/notifications_screen.dart';
import 'package:smn_admin/view/screens/order/order_details_screen.dart';
import 'package:smn_admin/view/screens/order/order_edit_screen.dart';
import 'package:smn_admin/view/screens/restaurants/create_restaurant/create_restaurant_first_screen.dart';
import 'package:smn_admin/view/screens/restaurants/create_restaurant/create_restaurant_second_screen.dart';
import 'package:smn_admin/view/screens/restaurants/create_restaurant/create_restaurant_third_screen.dart';
import 'package:smn_admin/view/screens/restaurants/create_restaurant/intro_create_restaurant_screen.dart';
import 'package:smn_admin/view/screens/restaurants/create_restaurant/wait_unactive_restaurant_screen.dart';
import 'package:smn_admin/view/screens/restaurants/edit_restaurant/edit_restaurant_first_screen.dart';
import 'package:smn_admin/view/screens/restaurants/edit_restaurant/edit_restaurant_second_screen.dart';
import 'package:smn_admin/view/screens/restaurants/edit_restaurant/edit_restaurant_third_screen.dart';
import 'package:smn_admin/view/screens/restaurants/map_widget.dart';
import 'package:smn_admin/view/screens/restaurants/restaurants_details_screen.dart';
import 'package:smn_admin/view/screens/settings/languages_screen.dart';
import 'package:smn_admin/view/screens/splash_screen.dart';
import 'package:smn_admin/view_models/auth_view_model.dart';
import 'package:smn_admin/view_models/faq_veiw_model.dart';
import 'package:smn_admin/view_models/messages_view_model.dart';
import 'package:smn_admin/view_models/notifications_view_model.dart';
import 'package:smn_admin/view_models/order_view_model.dart';
import 'package:smn_admin/view_models/restaurants_view_model.dart';
import 'package:smn_admin/view_models/setting_view_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Firebase.initializeApp");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationService.initializeNotifications();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.si<SettingViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<AuthViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<OrderViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<MessagesViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.si<NotificationsViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.si<RestaurantsViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<FaqViewModel>()),
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, settings, child) {
          return MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: settings.setting.mobileLanguage,
            supportedLocales: const [
              Locale("ar", ''),
              Locale("en", ''),
            ],
            home: const Scaffold(body: SplashScreen()),
            theme: settings.setting.brightness == Brightness.light
                ? ThemeData(
                    // fontFamily: 'MyriadPro',
                    primaryColor: Colors.white,
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            elevation: 0, foregroundColor: Colors.white),
                    brightness: Brightness.light,
                    accentColor: config.Colors(context).mainColor(1),
                    backgroundColor: Colors.white,
                    dividerColor: config.Colors(context).accentColor(0.1),
                    focusColor: config.Colors(context).accentColor(1),
                    hintColor: config.Colors(context).secondColor(1),
                    textTheme: TextTheme(
                      headline5: TextStyle(
                          fontSize: 20.0,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline4: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline3: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline2: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors(context).mainColor(1),
                          height: 1.35),
                      headline1: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors(context).secondColor(1),
                          height: 1.5),
                      subtitle1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline6: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).mainColor(1),
                          height: 1.35),
                      bodyText2: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      bodyText1: TextStyle(
                          fontSize: 14.0,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      caption: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).accentColor(1),
                          height: 1.35),
                    ),
                  )
                : ThemeData(
                    // fontFamily: 'MyriadPro',
                    primaryColor: Color(0xFF252525),
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: Color(0xFF2C2C2C),
                    accentColor: config.Colors(context).mainDarkColor(1),
                    dividerColor: config.Colors(context).accentColor(0.1),
                    hintColor: config.Colors(context).secondDarkColor(1),
                    focusColor: config.Colors(context).accentDarkColor(1),
                    textTheme: TextTheme(
                      headline5: TextStyle(
                          fontSize: 20.0,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline4: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline3: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline2: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors(context).mainDarkColor(1),
                          height: 1.35),
                      headline1: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.5),
                      subtitle1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline6: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).mainDarkColor(1),
                          height: 1.35),
                      bodyText2: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      bodyText1: TextStyle(
                          fontSize: 14.0,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      caption: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).secondDarkColor(0.6),
                          height: 1.35),
                    ),
                  ),
            onGenerateRoute: (settings) {
              NavigationService.context=context;
              var view;
              switch (settings.name) {
                case 'HomeScreen':
                  view = HomeScreen(
                    initialPage: settings.arguments as int,
                  );
                  break;
                case 'LoginScreen':
                  view = const LoginScreen();
                  break;
                case 'ForgetPassword':
                  view = const ForgetPasswordScreen();
                  break;
                case 'OrderDetailsScreen':
                  view = OrderDetailsScreen(
                    id: settings.arguments as String,
                  );
                  break;
                case 'OrderEditScreen':
                  view = OrderEditScreen(
                    id: settings.arguments as String,
                  );
                  break;
                case 'RestaurantsDetailsScreen':
                  view = RestaurantsDetailsScreen(
                    id: (settings.arguments as Map)['id'] as String,
                    heroTag: (settings.arguments as Map)['heroTag'] as String,
                  );
                  break;
                case 'MapWidget':
                  view = MapWidget();
                  break;
                case 'ChatScreen':
                  view = ChatScreen(
                    conversation: (settings.arguments as Map)['Conversation']
                        as Conversation,
                    restaurantId:
                        (settings.arguments as Map)['restaurantId'] as String,
                  );
                  break;
                case 'LanguagesScreen':
                  view = LanguagesScreen();
                  break;
                case 'HelpScreen':
                  view = const HelpScreen();
                  break;
                case 'NotificationsScreen':
                  view = const NotificationsScreen();
                  break;
                case 'IntroCreateRestaurantScreen':
                  view = IntroCreateRestaurantScreen(
                    userName: settings.arguments as String,
                  );
                  break;
                case 'CreateRestaurantScreen':
                  view = const CreateRestaurantFirstScreen();
                  break;
                case 'CreateRestaurantSecondScreen':
                  view = CreateRestaurantSecondScreen(
                    nameEn: (settings.arguments as Map)['nameEn'] as String,
                    nameAr: (settings.arguments as Map)['nameAr'] as String,
                    descriptionAr:
                        (settings.arguments as Map)['descriptionAr'] as String,
                    descriptionEn:
                        (settings.arguments as Map)['descriptionEn'] as String,
                    image: (settings.arguments as Map)['image'] as File,
                  );
                  break;
                case 'CreateRestaurantThirdScreen':
                  view = CreateRestaurantThirdScreen(
                    nameEn: (settings.arguments as Map)['nameEn'] as String,
                    nameAr: (settings.arguments as Map)['nameAr'] as String,
                    descriptionAr:
                        (settings.arguments as Map)['descriptionAr'] as String,
                    descriptionEn:
                        (settings.arguments as Map)['descriptionEn'] as String,
                    image: (settings.arguments as Map)['image'] as File,
                    address: (settings.arguments as Map)['address'] as String,
                    averageTime:
                        (settings.arguments as Map)['averageTime'] as String,
                    defaultTax:
                        (settings.arguments as Map)['defaultTax'] as String,
                    mobile: (settings.arguments as Map)['mobile'] as String,
                    phone: (settings.arguments as Map)['phone'] as String,
                    lat: (settings.arguments as Map)['lat'] as double,
                    lng: (settings.arguments as Map)['lng'] as double,
                  );
                  break;
                case 'EditRestaurantFirstScreen':
                  view = EditRestaurantFirstScreen(
                    restaurant: settings.arguments as Restaurant,
                  );
                  break;
                case 'EditRestaurantSecondScreen':
                  view = EditRestaurantSecondScreen(
                    restaurant:
                        (settings.arguments as Map)['restaurant'] as Restaurant,
                    image: (settings.arguments as Map)['image'],
                  );
                  break;
                case 'EditRestaurantThirdScreen':
                  view = EditRestaurantThirdScreen(
                    restaurant:
                        (settings.arguments as Map)['restaurant'] as Restaurant,
                    image: (settings.arguments as Map)['image'],
                  );
                  break;
                case 'CreateFoodScreen':
                  view = const CreateFoodScreen();
                  break;
                case 'EditFoodScreen':
                  view = EditFoodScreen(
                    food: settings.arguments as Food,
                  );
                  break;
                case 'WaiteUnActiveRestaurantScreen':
                  view = const WaiteUnActiveRestaurantScreen();
                  break;
                case 'SignupScreen':
                  view = const SignupScreen();
                  break;
              }
              return MaterialPageRoute(
                  builder: (context) => view, settings: settings);
            },
          );
        },
      ),
    );
  }
}

//C:\Program Files\Java\jdk-11.0.14\bin
