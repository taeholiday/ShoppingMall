import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_signout.dart';


class BuyerService extends StatefulWidget {
  BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}
