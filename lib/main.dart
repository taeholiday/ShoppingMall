import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/states/add_product.dart';
import 'package:shoppingmall/states/authan.dart';
import 'package:shoppingmall/states/buyer_service.dart';
import 'package:shoppingmall/states/create_account.dart';
import 'package:shoppingmall/states/rider_service.dart';
import 'package:shoppingmall/states/saler_service.dart';
import 'package:shoppingmall/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authan(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerSrevice': (BuildContext context) => BuyerService(),
  '/salerService': (BuildContext context) => SalerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/addProduct': (BuildContext context) => AddProduct(),
};

String? initleRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String? type = preferences.getString('type');
  print('type: $type EP 35.2');
  if (type?.isEmpty ?? true) {
    initleRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initleRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'saller':
        initleRoute = MyConstant.routeSalerService;
        runApp(MyApp());
        break;
      case 'rider':
        initleRoute = MyConstant.routeRiderService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xff575900, MyConstant.mapMatrtialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initleRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
