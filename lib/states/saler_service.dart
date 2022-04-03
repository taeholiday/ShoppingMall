import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class SalerService extends StatefulWidget {
  SalerService({Key? key}) : super(key: key);

  @override
  State<SalerService> createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saller'),
        backgroundColor: MyConstant.primary,
      ),
    );
  }
}
