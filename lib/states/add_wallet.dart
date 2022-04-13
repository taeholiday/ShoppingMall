import 'package:flutter/material.dart';
import 'package:shoppingmall/bodys/bank.dart';
import 'package:shoppingmall/bodys/credic.dart';
import 'package:shoppingmall/bodys/prompay.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class AddWallet extends StatefulWidget {
  AddWallet({Key? key}) : super(key: key);

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  List<Widget> widgets = [Bank(), Prompay(), Credic()];
  List<IconData> icons = [Icons.money, Icons.book, Icons.credit_card];
  List<String> titles = ['Bank', 'Prompay', 'Credic'];
  int indexPosition = 0;
  List<BottomNavigationBarItem> bottomNavigationBarItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int i = 0;
    for (var item in titles) {
      bottomNavigationBarItems
          .add(createBottomNavigationBarItem(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigationBarItem(
          IconData iconData, String string) =>
      BottomNavigationBarItem(
        icon: Icon(iconData),
        label: string,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Wallet from ${titles[indexPosition]}'),
        ),
        body: widgets[indexPosition],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: MyConstant.dark,
          unselectedItemColor: MyConstant.light,
          currentIndex: indexPosition,
          items: bottomNavigationBarItems,
          onTap: (value) {
            setState(() {
              indexPosition = value;
            });
          },
        ));
  }
}
