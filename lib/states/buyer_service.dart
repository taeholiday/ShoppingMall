import 'package:flutter/material.dart';
import 'package:shoppingmall/bodys/my_money_buyer.dart';
import 'package:shoppingmall/bodys/my_order_buyer.dart';
import 'package:shoppingmall/bodys/show_all_shop_buyer.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_signout.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class BuyerService extends StatefulWidget {
  BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> widgets = [ShowAllShopBuyer(), MyMoneyBuyer(), MyOrderBuyer()];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, MyConstant.routeShowCart),
              icon: Icon(Icons.shopping_cart_outlined))
        ],
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHeader(),
                menuShowAllShop(),
                menuMyMoney(),
                menuMyOrder(),
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowAllShop() {
    return ListTile(
      leading: Icon(
        Icons.shopping_bag_outlined,
        size: 36,
        color: MyConstant.dark,
      ),
      title:
          ShowTile(title: 'Show All Shop', textStyle: MyConstant().h2Style()),
      subtitle: ShowTile(
          title: 'เเสดงร้านค้า ทั้งหมด', textStyle: MyConstant().h3Style()),
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile menuMyMoney() {
    return ListTile(
      leading: Icon(
        Icons.money,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTile(title: 'My Money', textStyle: MyConstant().h2Style()),
      subtitle: ShowTile(
          title: 'เเสดงจำนวนเงิน ที่มี', textStyle: MyConstant().h3Style()),
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile menuMyOrder() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTile(title: 'MyOrder', textStyle: MyConstant().h2Style()),
      subtitle: ShowTile(
          title: 'เเสดงรายการสั่งของ', textStyle: MyConstant().h3Style()),
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
    );
  }

  UserAccountsDrawerHeader buildHeader() =>
      UserAccountsDrawerHeader(accountName: null, accountEmail: null);
}
