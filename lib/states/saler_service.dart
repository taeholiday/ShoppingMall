import 'package:flutter/material.dart';
import 'package:shoppingmall/bodys/shop_manage_seller.dart';
import 'package:shoppingmall/bodys/show_order_seller.dart';
import 'package:shoppingmall/bodys/show_product_seller.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_signout.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class SalerService extends StatefulWidget {
  SalerService({Key? key}) : super(key: key);

  @override
  State<SalerService> createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  List<Widget> widgets = [
    ShowOrderSeller(),
    ShopManageSeller(),
    ShowProductSeller()
  ];
  int indexWidget = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShopmanage(),
                menuShowProduct(),
              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTile(
        title: 'Show Order',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTile(
        title: 'เเสดรายละเอียดของออเดอร์ที่สั่ง',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShopmanage() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2_outlined),
      title: ShowTile(
        title: 'Shop Manage',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTile(
        title: 'เเสดรายละเอียดของหน้าร้านที่ให้ลูกค้าเห็น',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3_outlined),
      title: ShowTile(
        title: 'Show Product',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTile(
        title: 'เเสดรายละเอียดของสินค้าที่เราขาย',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
