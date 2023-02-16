import 'package:chiggy_wiggy/admin/api/coupon_api/coupon_api.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCoupon extends StatefulWidget {
  const AddCoupon({super.key});

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String couponType = 'Flat';
  var _formKey = GlobalKey<FormState>();
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  TextEditingController t1 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  bool isLoading = false;
  saveCoupon() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      CouponModel couponModel = CouponModel(
          name: t1.text,
          description: t3.text,
          type: couponType,
          startDate: startDate,
          endDate: endDate,
          minAmount: int.parse(t4.text),
          offAmount: int.parse(t2.text),
          usedById: []);
      CouponApi().addCoupon(couponModel).then((value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Add Coupon', context),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBoldText('Coupon name', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t1,
                        decoration: InputDecoration(
                          label: getNormalText('Coupon name', Colors.black, 14),
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
                      getBoldText('Coupon name', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      couponType = 'Flat';
                                    });
                                  },
                                  icon: couponType == 'Flat'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_off)),
                              getNormalText('Flat', Colors.black, 14),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      couponType = 'Percentage';
                                    });
                                  },
                                  icon: couponType == 'Percentage'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_off)),
                              getNormalText('Percentage', Colors.black, 14),
                            ],
                          ),
                        ],
                      ),
                      getBoldText(
                          couponType == 'Percentage'
                              ? 'Percent off'
                              : 'Amount off',
                          Colors.black,
                          13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: getNormalText(
                              couponType == 'Percentage'
                                  ? 'Percent off'
                                  : 'Amount off',
                              Colors.black,
                              14),
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
                      getBoldText('Minimum amount purchase', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label:
                              getNormalText('Minimum anount', Colors.black, 14),
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
                        controller: t3,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          label: getNormalText('Description', Colors.black, 14),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Start Date:', Colors.black, 14),
                          Row(
                            children: [
                              getNormalText(
                                  DateFormat('dd MMMM, yy').format(startDate),
                                  Colors.black,
                                  14),
                              IconButton(
                                  onPressed: () {
                                    _selectStartDate(context);
                                  },
                                  icon: Icon(Icons.calendar_today))
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('End Date:', Colors.black, 14),
                          Row(
                            children: [
                              getNormalText(
                                  DateFormat('dd MMMM, yy').format(endDate),
                                  Colors.black,
                                  14),
                              IconButton(
                                  onPressed: () {
                                    _selectEndDate(context);
                                  },
                                  icon: Icon(Icons.calendar_today))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: getButton('Save coupon', Colors.green, () {
                          saveCoupon();
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
