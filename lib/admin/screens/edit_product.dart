import 'dart:io';

import 'package:chiggy_wiggy/admin/api/product_api.dart/image_upload.dart';
import 'package:chiggy_wiggy/admin/api/product_api.dart/product_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/product_model.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const EditProduct({super.key, required this.data, required this.id});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
  bool? isAvailable;

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

  // we will create a method here to upload our image.
  Future uploadImage() async {
    File? imageFile;
    //  this is important as we don't want an error if we have not picked up image
    if (_file == null) return;
    imageFile = File(_file!.path);
    setState(() {
      isLoading = true;
    });
    final destination = 'product_image/${_file!.name}';
    // this will create a folder in firebase storage named product_image and store our image there, as u will see
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
    // this is the path for our image in firebase storage, lets print it
    // if image is uploaded successfully then we will upload product
    addProduct(imagePath);
    //lets test it out
  }

  addProduct(String imgUrl) async {
    // if our form is valid
    //also we have to check another condition
    // okay there is a fault here, before uploading the image we should check form state
    ProductModel productModel = ProductModel(
        name: t1.text,
        description: t4.text,
        price: t2.text,
        shortDescription: t3.text,
        weight: t5.text,
        imgUrl: imgUrl,
        category: selectedCategory!,
        isAvailable: isAvailable!);
    setState(() {
      isLoading = true;
    });
    await ProductApi().updateProduct(widget.id, productModel).then((value) {
      setState(() {
        isLoading = false;
      });

      getSnackbar('Product updated', context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackbar(error.toString(), context);
    });
  }

  setValues() {
    t1.text = widget.data['name'];
    t2.text = widget.data['price'];
    t3.text = widget.data['shortDescription'];
    t4.text = widget.data['description'];
    t5.text = widget.data['weight'];
    setState(() {
      selectedCategory = widget.data['category'];
      isAvailable = widget.data['isAvailable'];
    });
  }

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isAvailable = !isAvailable!;
                });
              },
              icon: isAvailable!
                  ? Icon(
                      Icons.toggle_on,
                      size: 40,
                    )
                  : Icon(
                      Icons.toggle_off,
                      size: 40,
                    ))
        ],
        flexibleSpace: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 250,
              color: MyColors.primaryColor,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              height: 20,
            )
          ],
        ),
      ),
      // we will give toggle button to our appbar
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
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Image.network(widget.data['imgUrl']),
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
                                    ],
                                  ),
                                )
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
                      child:
                          getButton('Update', MyColors.primaryColor, () async {
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
                          // we need to have two case here, one is when image is changed and other is when not
                          _file == null
                              ? addProduct(widget.data['imgUrl'])
                              : uploadImage();
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
