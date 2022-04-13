import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/models/sqlite_model.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/utility/sqlite_helper.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;
  ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowProductBuyer> createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool lond = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;
  int amountInt = 1;
  String? currentIdSeller;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readAPI();
    readCart();
  }

  Future<Null> readCart() async {
    await SQLiteHelper().readSQLite().then((value) {
      print('### value readCart ==> $value');
      if (value.isNotEmpty) {
        List<SQLiteModel> models = [];
        for (var model in value) {
          models.add(model);
        }
        currentIdSeller = models[0].idSeller;
        print('### currentIdSeller = $currentIdSeller');
      }
    });
  }

  Future<void> readAPI() async {
    String id = userModel!.id;
    String urlAPI =
        '${MyConstant.domain}/shoppingmallAPI/getProductWhereIdSeller.php?isAdd=true&idSeller=$id';
    await Dio().get(urlAPI).then(
      (value) {
        print('value ==>> $value');
        if (value.toString() == 'null') {
          setState(() {
            haveProduct = false;
            lond = false;
          });
        } else {
          for (var item in json.decode(value.data)) {
            ProductModel model = ProductModel.fromMap(item);

            String string = model.images;
            string = string.substring(1, string.length - 1);
            List<String> strings = string.split(',');
            int i = 0;
            for (var item in strings) {
              strings[i] = item.trim();
              i++;
            }
            listImages.add(strings);
            setState(() {
              haveProduct = true;
              lond = false;
              productModels.add(model);
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: lond
          ? ShowProgress()
          : haveProduct!
              ? listProduct()
              : Center(
                  child: ShowTile(
                      title: 'No Product', textStyle: MyConstant().h1Style()),
                ),
    );
  }

  LayoutBuilder listProduct() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print('### You Click Index ==>> $index');
              showAlertDialog(productModels[index], listImages[index]);
            },
            child: Card(
              child: Row(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.5 - 8,
                    height: constraints.maxWidth * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            ShowImage(path: MyConstant.image1),
                        placeholder: (context, url) => ShowProgress(),
                        imageUrl: findUrlImage(productModels[index].images),
                      ),
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxWidth * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTile(
                          title: productModels[index].name,
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTile(
                          title: 'Price = ${productModels[index].price} ฿',
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTile(
                          title: cutWord(
                              'Detail : ${productModels[index].detail}'),
                          textStyle: MyConstant().h2Style(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/shoppingmallAPI${strings[0]}';
    return result;
  }

  Future<Null> showAlertDialog(ProductModel productModel, List images) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: ListTile(
                  leading: ShowImage(path: MyConstant.image2),
                  title: ShowTile(
                      title: productModel.name,
                      textStyle: MyConstant().h2Style()),
                  subtitle: ShowTile(
                      title: 'Price = ${productModel.price} ฿',
                      textStyle: MyConstant().h3Style()),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        child: CachedNetworkImage(
                          placeholder: (context, url) => ShowProgress(),
                          imageUrl:
                              '${MyConstant.domain}/shoppingmallAPI${images[indexImage]}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 0;
                                  });
                                },
                                icon: Icon(Icons.filter_1)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 1;
                                  });
                                },
                                icon: Icon(Icons.filter_2)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 2;
                                  });
                                },
                                icon: Icon(Icons.filter_3)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    indexImage = 3;
                                  });
                                },
                                icon: Icon(Icons.filter_4)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          ShowTile(
                              title: 'รายละเอียด :',
                              textStyle: MyConstant().h2Style()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 200,
                              child: ShowTile(
                                  title: productModel.detail,
                                  textStyle: MyConstant().h3Style()),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (amountInt != 1) {
                                setState(() {
                                  amountInt--;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: MyConstant.dark,
                            ),
                          ),
                          ShowTile(
                            title: amountInt.toString(),
                            textStyle: MyConstant().h1Style(),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                amountInt++;
                              });
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: MyConstant.dark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () async {
                          String idSeller = userModel!.id;
                          String idProduct = productModel.id;
                          String name = productModel.name;
                          String price = productModel.price;
                          String amount = amountInt.toString();
                          int sumInt = int.parse(price) * amountInt;
                          String sum = sumInt.toString();
                          print(
                              '### curentIdSeller = $currentIdSeller, idSeller ==>> $idSeller, idProduct = $idProduct, name = $name, price = $price, amount = $amount, sum = $sum');
                          if ((currentIdSeller == idSeller) ||
                              (currentIdSeller == null)) {
                            SQLiteModel sqLiteModel = SQLiteModel(
                                idSeller: idSeller,
                                idProduct: idProduct,
                                name: name,
                                price: price,
                                amount: amount,
                                sum: sum);
                            await SQLiteHelper()
                                .insertValueToSQLite(sqLiteModel)
                                .then((value) {
                              amountInt = 1;
                              Navigator.pop(context);
                            });
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            MyDialog().nomalDialog(context, 'ร้านผิด ?',
                                'กรุณาเลือกสินค้าที่ ร้านเดิม ให้เสร็จก่อน เลือกร้านอื่น คะ');
                          }
                        },
                        child: ShowTile(
                            title: 'Add Cart',
                            textStyle: MyConstant().h2BlueStyle()),
                      ),
                      TextButton(
                        onPressed: () {
                          amountInt = 1;
                          Navigator.pop(context);
                        },
                        child: ShowTile(
                            title: 'Cancel',
                            textStyle: MyConstant().h2RedStyle()),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  cutWord(String string) {
    String result = string;
    if (result.length >= 50) {
      result = result.substring(0, 50);
      result = '$result...';
    }
    return result;
  }
}
