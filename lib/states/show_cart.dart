import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/sqlite_model.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/sqlite_helper.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowCart extends StatefulWidget {
  ShowCart({Key? key}) : super(key: key);

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  int? total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQLite();
  }

  Future<Null> processReadSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
    }
    await SQLiteHelper().readSQLite().then((value) {
      print('value = $value');
      setState(() {
        load = false;
        sqliteModels = value;
        findDetailSeller();
        calculateTotal();
      });
    });
  }

  void calculateTotal() async {
    total = 0;
    for (var item in sqliteModels) {
      int sumInt = int.parse(item.sum.trim());
      setState(() {
        total = total! + sumInt;
      });
    }
  }

  Future<void> findDetailSeller() async {
    if (sqliteModels.length != 0) {
      String idSeller = sqliteModels[0].idSeller;
      String apiGetUserWhereId =
          '${MyConstant.domain}/shoppingmallAPI/getUserWhereId.php?isAdd=true&id=$idSeller';

      await Dio().get(apiGetUserWhereId).then((value) {
        for (var item in json.decode(value.data)) {
          setState(() {
            userModel = UserModel.fromMap(item);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Cart'),
      ),
      body: load
          ? ShowProgress()
          : sqliteModels.length == 0
              ? buildNoOrder()
              : buildContent(),
    );
  }

  Center buildNoOrder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: 200,
            child: ShowImage(path: MyConstant.image1),
          ),
          ShowTile(title: 'No Order', textStyle: MyConstant().h1Style()),
        ],
      ),
    );
  }

  Column buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showSeller(),
        buildHead(),
        listProduct(),
        buildDivider(),
        buildTotal(),
        buildDivider(),
        buttonController(),
      ],
    );
  }

  Future<void> confrimEmptyCart() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(
            path: MyConstant.image4,
          ),
          title: ShowTile(
              title: 'คุณต้องการจะ Delete ?',
              textStyle: MyConstant().h2BlueStyle()),
          subtitle: ShowTile(
            title: 'Product ทั้งหมดใน ตะกร้า ใช่ไหม',
            textStyle: MyConstant().h3Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await SQLiteHelper().emptySQLite().then((value) {
                Navigator.pop(context);
                processReadSQLite();
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Row buttonController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, MyConstant.routeAddWallet);
          },
          child: Text('Order'),
        ),
        Container(
          margin: EdgeInsets.only(left: 4, right: 8),
          child: ElevatedButton(
            onPressed: () => confrimEmptyCart(),
            child: Text('Empty Cart'),
          ),
        ),
      ],
    );
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTile(title: 'Total :', textStyle: MyConstant().h2BlueStyle()),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShowTile(
                  title: total == null ? '' : total.toString(),
                  textStyle: MyConstant().h1Style()),
            ],
          ),
        ),
      ],
    );
  }

  Divider buildDivider() => Divider(color: MyConstant.dark);

  ListView listProduct() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ShowTile(
                    title: sqliteModels[index].name,
                    textStyle: MyConstant().h3Style()),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTile(
                  title: sqliteModels[index].price,
                  textStyle: MyConstant().h3Style()),
            ),
            Expanded(
              flex: 1,
              child: ShowTile(
                  title: sqliteModels[index].amount,
                  textStyle: MyConstant().h3Style()),
            ),
            Expanded(
              flex: 1,
              child: ShowTile(
                  title: sqliteModels[index].sum,
                  textStyle: MyConstant().h3Style()),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () async {
                    int idSQLite = sqliteModels[index].id!;
                    print('delete id ==>> $idSQLite');
                    await SQLiteHelper()
                        .deleteSQLiteWhereId(idSQLite)
                        .then((value) => processReadSQLite());
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red.shade700,
                  )),
            ),
          ],
        );
      },
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: MyConstant.light),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child:
                  ShowTile(title: 'Product', textStyle: MyConstant().h2Style()),
            ),
            Expanded(
              flex: 1,
              child:
                  ShowTile(title: 'Price', textStyle: MyConstant().h2Style()),
            ),
            Expanded(
              flex: 1,
              child: ShowTile(title: 'Amt', textStyle: MyConstant().h2Style()),
            ),
            Expanded(
              flex: 1,
              child: ShowTile(title: 'Sum', textStyle: MyConstant().h2Style()),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Padding showSeller() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTile(
          title: userModel == null ? '' : userModel!.name,
          textStyle: MyConstant().h1Style()),
    );
  }
}
