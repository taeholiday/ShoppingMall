import 'package:flutter/material.dart';

class ShowOrderSeller extends StatefulWidget {
  ShowOrderSeller({Key? key}) : super(key: key);

  @override
  State<ShowOrderSeller> createState() => _ShowOrderSellerState();
}

class _ShowOrderSellerState extends State<ShowOrderSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('this is showorder'),
    );
  }
}
