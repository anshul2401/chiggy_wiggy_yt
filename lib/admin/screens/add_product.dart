import 'dart:io';

import 'package:chiggy_wiggy/admin/api/product_api.dart/image_upload.dart';
import 'package:chiggy_wiggy/admin/api/product_api.dart/product_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/product_model.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  List<String> categories = ['Chicken', 'Mutton', 'Seafood', 'Egg'];
  String? selectedCategory;
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  bool isLoading = false;

  Future selectImageFromGallery() async {
    final XFile? pic = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = pic;
    });
  }

  Future selectImageFromCamera() async {
    final XFile? pic = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _file = pic;
    });
  }

  Future uploadImage() async {
    File? imageFile;

    if (_file == null) return;
    imageFile = File(_file!.path);
    setState(() {
      isLoading = true;
    });
    final destination = 'product_image/${_file!.name}';

    var task = FirebaseImageUploadApi.uploadImage(destination, imageFile);
    if (task == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final snapshot = await task.whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
    final imagePath = await snapshot.ref.getDownloadURL();

    addProduct(imagePath);
  }

  addProduct(String imgUrl) async {
    ProductModel productModel = ProductModel(
      name: t1.text,
      description: t4.text,
      price: t2.text,
      shortDescription: t3.text,
      weight: t5.text,
      imgUrl: imgUrl,
      category: selectedCategory!,
      isAvailable: true,
    );
    setState(() {
      isLoading = true;
    });
    await ProductApi().addProduct(productModel).then((value) {
      setState(() {
        isLoading = false;
      });

      getSnackbar('Product added', context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackbar(error.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Add Product', context),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getBoldText('Image', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: _file == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getNormalText(
                                    'No Image Selected', Colors.grey, 14),
                                SizedBox(
                                  height: 3,
                                ),
                                getButton('Add Image', Colors.blue, () {
                                  showBottomSheet();
                                }),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Image.file(File(_file!.path)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      getButton('Edit', Colors.amber, () {
                                        showBottomSheet();
                                      }),
                                      getButton('Delete', Colors.red, () {
                                        setState(() {
                                          _file = null;
                                        });
                                      })
                                    ],
                                  ),
                                )
                              ],
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getBoldText('Product name', Colors.black, 13),
                          SizedBox(
                            height: 3,
                          ),
                          TextFormField(
                            controller: t1,
                            decoration: InputDecoration(
                              label: getNormalText(
                                  'Product name', Colors.black, 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getBoldText('Price', Colors.black, 13),
                          SizedBox(
                            height: 3,
                          ),
                          TextFormField(
                            controller: t2,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: getNormalText('Price', Colors.black, 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getBoldText('Short Description', Colors.black, 13),
                          SizedBox(
                            height: 3,
                          ),
                          TextFormField(
                            controller: t3,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              label: getNormalText(
                                  'Short Description', Colors.black, 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getBoldText('Description', Colors.black, 13),
                          SizedBox(
                            height: 3,
                          ),
                          TextFormField(
                            controller: t4,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              label: getNormalText(
                                  'Description', Colors.black, 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          getBoldText('Weight (in gm)', Colors.black, 13),
                          SizedBox(
                            height: 3,
                          ),
                          TextFormField(
                            controller: t5,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: getNormalText(
                                  'Weight (in gm)', Colors.black, 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getBoldText('Select Category', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        isExpanded: true,
                        itemHeight: 60,
                        elevation: 0,
                        value: selectedCategory,
                        underline: Container(),
                        hint:
                            getNormalText('Select Category', Colors.black, 14),
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: getNormalText(value, Colors.black, 14));
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            selectedCategory = _ as String?;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: getButton('Save Product', MyColors.primaryColor,
                          () async {
                        if (_formKey.currentState!.validate()) {
                          //also one more check
                          if (selectedCategory == null) {
                            //lets create a snackbar
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: getNormalText(
                                    'Please select a category',
                                    Colors.white,
                                    14)));
                            return;
                          }
                          if (_file == null) {
                            //lets create a snackbar
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: getNormalText('Please select an image',
                                    Colors.white, 14)));
                            return;
                          }
                          uploadImage();
                        }
                      }),
                    ),
                    //lets teest it
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    selectImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(0.2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 50,
                          color: MyColors.primaryColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        getBoldText('Camera', Colors.black, 16),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    selectImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red.withOpacity(0.2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: MyColors.primaryColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        getBoldText('Gallery', Colors.black, 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
