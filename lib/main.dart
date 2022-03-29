import 'package:flutter/material.dart';
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
};

String? initleRoute;

void main() {
  initleRoute = MyConstant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initleRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
