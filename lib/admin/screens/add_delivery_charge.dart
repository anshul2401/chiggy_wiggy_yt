import 'package:chiggy_wiggy/admin/api/delivery_charges_api.dart/delivery_charges_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/delivery_charges_model.dart';
import 'package:flutter/material.dart';

class AddDeliveryCharge extends StatefulWidget {
  const AddDeliveryCharge({super.key});

  @override
  State<AddDeliveryCharge> createState() => _AddDeliveryChargeState();
}

class _AddDeliveryChargeState extends State<AddDeliveryCharge> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  bool isLoading = false;
  addDeliveryCharge() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      DeliveryChargeModel deliveryChargeModel =
          DeliveryChargeModel(name: t1.text, deliveryCharge: t2.text);
      DeliveryChargeApi().addDeliveryCharges(deliveryChargeModel).then((value) {
        setState(() {
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        getSnackbar(error.toString(), context);
      });
    }
  }

  var _formKey = GlobalKey<FormState>();
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
                        addDeliveryCharge();
                      }),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
