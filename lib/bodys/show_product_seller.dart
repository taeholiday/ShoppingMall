import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/states/edit_product.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowProductSeller extends StatefulWidget {
  ShowProductSeller({Key? key}) : super(key: key);

  @override
  State<ShowProductSeller> createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool? haveDate;
  List<ProductModel> productModels = [];
  @override
  void initState() {
    super.initState();
    londValueFromAPI();
  }

  Future<Null> londValueFromAPI() async {
    if (productModels.length != 0) {
      productModels.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String apiProductWhereIdSeller =
        '${MyConstant.domain}/shoppingmallAPI/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(apiProductWhereIdSeller).then((value) {
      // print('value ==> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveDate = false;
        });
      } else {
        //Heve Data
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('name Product ==>> ${model.name}');
          setState(() {
            load = false;
            haveDate = true;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveDate!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTile(
                        title: 'No Product',
                        textStyle: MyConstant().h1Style(),
                      ),
                      ShowTile(
                          title: 'Please Add Product',
                          textStyle: MyConstant().h2Style())
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct)
                .then((value) => londValueFromAPI()),
        child: Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/shoppingmallAPI${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.5 - 4,
                height: constraints.maxWidth * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShowTile(
                        title: productModels[index].name,
                        textStyle: MyConstant().h2Style()),
                    Container(
                      height: constraints.maxWidth * 0.4,
                      width: constraints.maxWidth * 0.5,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: createUrl(productModels[index].images),
                        placeholder: (context, url) => ShowProgress(),
                        errorWidget: (context, url, error) => ShowImage(
                          path: MyConstant.image5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(4),
                width: constraints.maxWidth * 0.5 - 4,
                height: constraints.maxWidth * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTile(
                        title: 'Price ${productModels[index].price} ฿',
                        textStyle: MyConstant().h2Style()),
                    ShowTile(
                        title: productModels[index].detail,
                        textStyle: MyConstant().h3Style()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('## You Click Edit');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProduct(
                                    productModel: productModels[index],
                                  ),
                                )).then((value) => londValueFromAPI());
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 36,
                            color: MyConstant.dark,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            confirmDialogDelete(productModels[index]);
                          },
                          icon: Icon(
                            Icons.delete_outlined,
                            size: 36,
                            color: MyConstant.dark,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: createUrl(productModel.images),
                  placeholder: (context, url) => ShowProgress(),
                  errorWidget: (context, url, error) => ShowImage(
                    path: MyConstant.image5,
                  ),
                ),
                title: ShowTile(
                    title: 'Delete ${productModel.name} ?',
                    textStyle: MyConstant().h2Style()),
                subtitle: ShowTile(
                    title: productModel.detail,
                    textStyle: MyConstant().h3Style()),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      print('## Comfirm Delete at id ==> ${productModel.id}');
                      String id = productModel.id;
                      String apiDeleteProductWhereId =
                          '${MyConstant.domain}/shoppingmallAPI/deleteProductWhereId.php?isAdd=true&id=$id';
                      await Dio().get(apiDeleteProductWhereId).then((value) {
                        Navigator.pop(context);
                        londValueFromAPI();
                      });
                    },
                    child: Text('Delete')),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cencel')),
              ],
            ));
  }
}
