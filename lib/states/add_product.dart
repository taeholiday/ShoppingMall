import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iniitalFile();
  }

  void iniitalFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildProductName(constraints),
                      buildProductPrice(constraints),
                      buildProductDetail(constraints),
                      buildImage(constraints),
                      addProductButton(constraints)
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

  Container addProductButton(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.75,
        child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate()) {}
            },
            child: Text(
              'Add Product',
            )));
  }

  Future<Null> processSourceImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );

      setState(() {
        file = File(result!.path);
        // files[index] = File(result.path);
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('click from index index ===>> $index');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                leading: ShowImage(path: MyConstant.image4),
                title: ShowTile(
                    title: 'Sourse Image ${index + 1} ?',
                    textStyle: MyConstant().h2Style()),
                subtitle: ShowTile(
                    title: 'Please Tab on Camara or Gallery',
                    textStyle: MyConstant().h3Style()),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        processSourceImagePicker(ImageSource.camera, index);
                      },
                      child: Text('Camera'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        processSourceImagePicker(ImageSource.gallery, index);
                      },
                      child: Text('Gallery'),
                    ),
                  ],
                )
              ],
            ));
  }

  Widget buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
            width: constraints.maxWidth * 0.75,
            height: constraints.maxWidth * 0.75,
            child: file == null
                ? Image.asset(MyConstant.image5)
                : Image.file(file!)),
        Container(
          width: constraints.maxWidth * 0.76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: Image.asset(MyConstant.image5),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                    onTap: () => chooseSourceImageDialog(1),
                    child: Image.asset(MyConstant.image5)),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                    onTap: () => chooseSourceImageDialog(2),
                    child: Image.asset(MyConstant.image5)),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                    onTap: () => chooseSourceImageDialog(3),
                    child: Image.asset(MyConstant.image5)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
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
    );
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
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
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
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
    );
  }
}
