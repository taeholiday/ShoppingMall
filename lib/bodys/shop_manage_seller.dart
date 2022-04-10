import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShopManageSeller extends StatefulWidget {
  final UserModel userModel;
  ShopManageSeller({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShopManageSeller> createState() => _ShopManageSellerState();
}

class _ShopManageSellerState extends State<ShopManageSeller> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('## refreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmallAPI/getUserWhereId.php?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyConstant.primary,
          child: Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(context, MyConstant.routeEditProfileSaler)
              .then((value) => refreshUserModel()),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTile(
                      title: 'Name Shop :', textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTile(
                          title: userModel!.name,
                          textStyle: MyConstant().h1Style()),
                    ],
                  ),
                  ShowTile(
                      title: 'Address :', textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ShowTile(
                            title: userModel!.address,
                            textStyle: MyConstant().h2Style(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ShowTile(
                      title: 'Phone : ${userModel!.phone}',
                      textStyle: MyConstant().h2Style()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ShowTile(
                        title: 'Avatar :', textStyle: MyConstant().h2Style()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        width: constraints.maxWidth * 0.6,
                        child: CachedNetworkImage(
                          imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                          placeholder: (context, url) => ShowProgress(),
                        ),
                      ),
                    ],
                  ),
                  ShowTile(
                      title: 'Location :', textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        width: constraints.maxWidth * 0.6,
                        height: constraints.maxWidth * 0.6,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            zoom: 16,
                          ),
                          markers: <Marker>[
                            Marker(
                                markerId: MarkerId('id'),
                                position: LatLng(
                                  double.parse(userModel!.lat),
                                  double.parse(userModel!.lng),
                                ),
                                infoWindow: InfoWindow(
                                    title: 'You Here ',
                                    snippet:
                                        'lat = ${userModel!.lat}, lng = ${userModel!.lng}')),
                          ].toSet(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
