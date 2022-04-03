import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class RiderService extends StatefulWidget {
  RiderService({Key? key}) : super(key: key);

  @override
  State<RiderService> createState() => _RiderServiceState();
}

class _RiderServiceState extends State<RiderService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider'),
        backgroundColor: MyConstant.primary,
      ),
    );
  }
}
