import 'package:chiggy_wiggy/admin/api/delivery_charges_api.dart/delivery_charges_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/delivery_charges_model.dart';
import 'package:flutter/material.dart';

class UpdateDeliveryCharge extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  const UpdateDeliveryCharge({super.key, required this.id, required this.data});

  @override
  State<UpdateDeliveryCharge> createState() => _UpdateDeliveryChargeState();
}

class _UpdateDeliveryChargeState extends State<UpdateDeliveryCharge> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  bool isLoading = false;
  updateDeliveryCharge() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      DeliveryChargeModel deliveryChargeModel =
          DeliveryChargeModel(name: t1.text, deliveryCharge: t2.text);
      DeliveryChargeApi()
          .updateDeliveryCharge(
        widget.id,
        deliveryChargeModel,
      )
          .then((value) {
        setState(() {
          isLoading = false;
        });
        getSnackbar('Updated', context);
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        getSnackbar(error.toString(), context);
      });
    }
  }

  var _formKey = GlobalKey<FormState>();
  setValues() {
    t1.text = widget.data['name'];
    t2.text = widget.data['deliveryCharge'];
  }

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Add Delivery Charge', context),
      body: isLoading
          ? getLoading()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getBoldText('Area name', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: t1,
                      decoration: InputDecoration(
                        label: getNormalText('Area name', Colors.black, 14),
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
                      height: 20,
                    ),
                    getBoldText('Delivery Charge', Colors.black, 13),
                    SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: t2,
                      decoration: InputDecoration(
                        label:
                            getNormalText('Delivery Charge', Colors.black, 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: getButton('Save', MyColors.primaryColor, () {
                        updateDeliveryCharge();
                      }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
