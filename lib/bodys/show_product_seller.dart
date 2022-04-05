import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class ShowProductSeller extends StatefulWidget {
  ShowProductSeller({Key? key}) : super(key: key);

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  @override
  void initState() {
    super.initState();
    londValueFromAPI();
  }

  Future<Null> londValueFromAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiProductWhereIdSeller =
        '${MyConstant.domain}/shoppingmallAPI/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(apiProductWhereIdSeller).then((value) {
      // print('value ==> $value');
      for (var item in json.decode(value.data)) {
        ProductModel model = ProductModel.fromMap(item);
        print('name Product ==>> ${model.name}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('this is showproduct'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct),
        child: Text('Add'),
      ),
    );
  }
}
