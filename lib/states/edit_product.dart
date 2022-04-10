import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_progress.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class EditProduct extends StatefulWidget {
  final ProductModel productModel;
  EditProduct({Key? key, required this.productModel}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false; // false =>> Not Change Image

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel;
    // print('## name Edit ==> ${productModel!.name}');
    convertStrindToArray();
    nameController.text = productModel!.name;
    priceController.text = productModel!.price;
    detailController.text = productModel!.detail;
  }

  void convertStrindToArray() {
    String string = productModel!.images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      files.add(null);
    }
    print(pathImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => processEdit(),
            icon: Icon(Icons.edit),
            tooltip: 'Edit Product',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle('General'),
                      buildName(constraints),
                      buildPrice(constraints),
                      buildDetail(constraints),
                      buildTitle('Image Product :'),
                      buildImage(constraints, 0),
                      buildImage(constraints, 1),
                      buildImage(constraints, 2),
                      buildImage(constraints, 3),
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        width: constraints.maxWidth,
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                            label: Text('Edit Product')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> chooseImage(int index, ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        files[index] = File(result!.path);
        statusImage = true;
      });
    } catch (e) {}
  }

  Container buildImage(BoxConstraints constraints, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(border: Border.all(color: MyConstant.dark)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                chooseImage(index, ImageSource.camera);
              },
              icon: Icon(
                Icons.add_a_photo,
                size: 36,
                color: MyConstant.dark,
              )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: constraints.maxWidth * 0.5,
            height: constraints.maxWidth * 0.5,
            child: files[index] == null
                ? CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}/shoppingmallAPI${pathImages[index]}',
                    placeholder: (context, url) => ShowProgress(),
                  )
                : Image.file(files[index]!),
          ),
          IconButton(
              onPressed: () {
                chooseImage(index, ImageSource.gallery);
              },
              icon: Icon(
                Icons.add_photo_alternate,
                size: 36,
                color: MyConstant.dark,
              )),
        ],
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name in Blank';
              } else {
                return null;
              }
            },
            controller: nameController,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Name Product :',
              prefixIcon: Icon(
                Icons.production_quantity_limits_sharp,
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

  Row buildPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Price in Blank';
              } else {
                return null;
              }
            },
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Price Product :',
              prefixIcon: Icon(
                Icons.attach_money,
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

  Row buildDetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Detail in Blank';
              } else {
                return null;
              }
            },
            controller: detailController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Product Detail :',
              hintStyle: MyConstant().h3Style(),
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(
                  Icons.details_outlined,
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

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTile(title: title, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String name = nameController.text;
      String price = priceController.text;
      String detail = detailController.text;
      String id = productModel!.id;
      String images;
      if (statusImage) {
        //upload Image and Refresh array pathImages
        int index = 0;
        for (var item in files) {
          if (item != null) {
            int i = Random().nextInt(1000000);
            String nameImage = 'productEdit$i.jpg';
            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            String apiUploadProduct =
                '${MyConstant.domain}/shoppingmallAPI/saveProduct.php';
            await Dio().post(apiUploadProduct, data: formData).then((value) {
              pathImages[index] = '/product/$nameImage';
            });
          }
          index++;
        }
        images = pathImages.toString();
        Navigator.pop(context);
      } else {
        images = pathImages.toString();
        Navigator.pop(context);
      }
      print('id => $id, name => $name, price => $price, detail => $detail');
      print('image =>> $images');

      String apiEditProduct =
          '${MyConstant.domain}/shoppingmallAPI/editProductWhereId.php?isAdd=true&id=$id&name=$name&price=$price&detail=$detail&images=$images';
      await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    }
  }
}
