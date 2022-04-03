import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';

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
        backgroundColor: MyConstant.primary,
      ),
    );
  }
}
