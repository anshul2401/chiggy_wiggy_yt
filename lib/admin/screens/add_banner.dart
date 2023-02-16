import 'dart:io';

import 'package:chiggy_wiggy/admin/api/banner_api.dart';
import 'package:chiggy_wiggy/admin/api/product_api.dart/image_upload.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  bool isLoading = false;
  // we will copy image upload code from our add produuct screen
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
    final destination = 'banner_image/${_file!.name}';

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
    BannerAPi().updateBanner(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Add banner', context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getBoldText('Banner', Colors.black, 13),
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
                          getNormalText('No Image Selected', Colors.grey, 14),
                          SizedBox(
                            height: 3,
                          ),
                          getButton('Add banner', Colors.blue, () {
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              getButton('Save', Colors.green, () {
                uploadImage();
              })
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
