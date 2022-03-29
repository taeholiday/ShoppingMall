import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';

class Authan extends StatefulWidget {
  Authan({Key? key}) : super(key: key);

  @override
  State<Authan> createState() => _AuthanState();
}

class _AuthanState extends State<Authan> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size * 0.6,
          child: ShowImage(path: MyConstant.image4),
        ),
      ),
    );
  }
}
