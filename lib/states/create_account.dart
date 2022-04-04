import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool statusRedEye = true;
  String? typeUser;
  String avatar = '';
  File? file;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Service Location Open');

      locationPermission = await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดเเชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'ไม่อนุญาติแชร์ Location', 'โปรดเเชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      }
    } else {
      print('Service Location Close');
      MyDialog().alertLocationService(
          context, 'Location Service ปิดอยู่ ?', 'กรุณาเปิด Location Service ');
    }
  }

  Future<Null> findLatLng() async {
    print('findLatLng ==> Work');
    Position? position = await findPostion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat =$lat, lng =$lng');
    });
  }

  Future<Position?> findPostion() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildCreateNewAccount(context),
        ],
        title: Text('Create New Account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  buildTitle('ข้อมูลทั่วไป'),
                  buildName(size),
                  buildTitle('ชนิดของ User :'),
                  buildRadioBuyer(size),
                  buildRadioSaller(size),
                  buildRadioRider(size),
                  buildTitle('ข้อมูลพื้นฐาน'),
                  buildAddress(size),
                  buildPhone(size),
                  buildUser(size),
                  buildPassword(size),
                  buildTitle('รูปภาพ'),
                  buildSubTitle(),
                  buildAvatar(size),
                  buildTitle('เเสดงพิกัดที่คุณอยู่'),
                  buildMap()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildCreateNewAccount(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (typeUser == null) {
            print('Non Choose Type User');
            MyDialog().nomalDialog(
                context, 'ยังไม่ได้เลือกชนิดของ User', 'กรุณาเลือกชนิด User');
          } else {
            print('Process Insert to Daatabase');
            uplondPictureAndInsertData();
          }
        }
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  Future<Null> uplondPictureAndInsertData() async {
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;
    print(
        '## name = $name, address = $address, phone = $phone, user = $user, password = $password');
    String path =
        '${MyConstant.domain}/shoppingmallAPI/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(path).then((value) async {
      print('## value ===>>> $value');
      if (value.toString() == 'null') {
        print('## user OK');

        if (file == null) {
          //No Avatar
          processInsertMySQL(
            name: name,
            address: address,
            phone: phone,
            user: user,
            password: password,
          );
        } else {
          //Have Avatar
          print('## process Uplond Avatar');
          String aipSaveAvatar =
              '${MyConstant.domain}/shoppingmallAPI/saveAvatar.php';
          int i = Random().nextInt(100000);
          String nameAvatar = 'avatar$i.jpg';
          Map<String, dynamic> map = Map();
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post(aipSaveAvatar, data: data).then((value) {
            avatar = '/shoppingmall/avatar/$nameAvatar';
            processInsertMySQL(
              name: name,
              address: address,
              phone: phone,
              user: user,
              password: password,
            );
          });
        }
      } else {
        MyDialog().nomalDialog(context, 'User False ?', 'Please Change User');
      }
    });
  }

  Future<Null> processInsertMySQL(
      {String? name,
      String? address,
      String? phone,
      String? user,
      String? password}) async {
    print('## processInsertMySQL Work and avatar ===>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/shoppingmallAPI/insertUser.php?isAdd=true&name=$name&type=$typeUser&address=$address&phone=$phone&user=$user&password=$password&avatar=$avatar&lat=$lat&lng=$lng';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().nomalDialog(
            context, 'Create New User False !!!', 'Please Try Again');
      }
    });
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
            markerId: MarkerId('id'),
            position: LatLng(lat!, lng!),
            infoWindow: InfoWindow(
                title: 'คุณอยู่ที่นี่', snippet: 'lat = $lat, lng = $lng'))
      ].toSet();

  Widget buildMap() => Container(
        width: double.infinity,
        height: 200.00,
        child: lat == null
            ? ShowProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat!, lng!),
                  zoom: 16,
                ),
                onMapCreated: (controller) {},
                markers: setMarker(),
              ),
      );

  Future<void> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.avatar)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  ShowTile buildSubTitle() {
    return ShowTile(
        title:
            'เป็นรูปภาพ ที่เเสดงความเป็นตัวตนของ User (เเต่ถ้าไม่ สะดวกเเชร์ เราจะเเสดงภาพ default แทน)',
        textStyle: MyConstant().h3Style());
  }

  Widget buildRadioBuyer(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'buyer',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value.toString();
              });
            },
            title: ShowTile(
              title: 'ผู้ซื้อ (Buyer)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRadioSaller(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'saller',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value.toString();
              });
            },
            title: ShowTile(
              title: 'ผู้ขาย (Seller)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRadioRider(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.6,
          child: RadioListTile(
            value: 'rider',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value.toString();
              });
            },
            title: ShowTile(
              title: 'ผู้ส่ง (Rider)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTitle(String title) => Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            child: ShowTile(
              title: title,
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ],
      );

  Row buildName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Name';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name :',
              prefixIcon: Icon(
                Icons.fingerprint,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(20)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Address';
              } else {
                return null;
              }
            },
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Address :',
              hintStyle: MyConstant().h3Style(),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(
                  Icons.home_outlined,
                  color: MyConstant.dark,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(20)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทร';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Phon :',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(20)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก User';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'User :',
              prefixIcon: Icon(
                Icons.perm_identity,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(20)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: size * 0.6,
          child: TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Password';
              } else {
                return null;
              }
            },
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: Icon(
                  statusRedEye
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                  color: MyConstant.dark,
                ),
              ),
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password :',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: MyConstant.dark,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.dark),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyConstant.light),
                  borderRadius: BorderRadius.circular(20)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }
}
