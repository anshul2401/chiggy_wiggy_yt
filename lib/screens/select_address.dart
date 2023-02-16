import 'package:chiggy_wiggy/admin/api/coupon_api/coupon_api.dart';
import 'package:chiggy_wiggy/admin/api/delivery_charges_api.dart/delivery_charges_api.dart';
import 'package:chiggy_wiggy/admin/api/order_api.dart/order_api.dart';
import 'package:chiggy_wiggy/admin/api/product_api.dart/user_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/cart_model.dart';
import 'package:chiggy_wiggy/models/coupon_model.dart';
import 'package:chiggy_wiggy/models/delivery_charges_model.dart';
import 'package:chiggy_wiggy/models/order_model.dart';
import 'package:chiggy_wiggy/models/user_model.dart';
import 'package:chiggy_wiggy/providers/cart_provider.dart';
import 'package:chiggy_wiggy/screens/order_success.dart';
import 'package:chiggy_wiggy/screens/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  List<DeliveryChargeModel> areas = [];
  bool isLoading = false;
  int deliveryCharge = 0;
  String? msg;
  var _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  CouponModel? usecoupon;
  getAreas() async {
    setState(() {
      isLoading = true;
    });
    List<DeliveryChargeModel> tempList;
    tempList = await DeliveryChargeApi().getArea();
    areas.addAll(tempList);
    setState(() {
      isLoading = false;
    });
  }

  AddressModel? selectedAddress;

  @override
  void initState() {
    getAreas();
    super.initState();
  }

  getDeliveryCharge() {
    DeliveryChargeModel area = areas.firstWhere((element) {
      return element.name == selectedAddress!.area;
    });
    setState(() {
      deliveryCharge = int.parse(area.deliveryCharge);
    });
  }

  addOrder() {
    if (selectedAddress == null) {
      getSnackbar('Please select a delivery address', context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    List<CartModel> items = [];
    Provider.of<CartProvider>(context, listen: false)
        .cartItem
        .forEach((key, value) {
      items.add(value);
    });
    String totalAmount =
        (Provider.of<CartProvider>(context, listen: false).getTotalAmount() +
                deliveryCharge -
                (usecoupon == null ? 0 : usecoupon!.offAmount))
            .toString();
    OrderModel order = OrderModel(
        userId: currentUser!.id,
        address: selectedAddress!,
        name: currentUser!.name,
        dateTime: DateTime.now(),
        date: DateFormat('dd:MM:yy').format(DateTime.now()),
        items: items,
        phoneNumber: currentUser!.phoneNum,
        totalAmount: totalAmount,
        status: 'Pending');
    OrderApi().addOrder(order).then((value) {
      usecoupon != null
          ? CouponApi().getAndUpdateCopon(t1.text).then((value) {
              setState(() {
                isLoading = false;
              });
            })
          : null;
      setState(() {
        isLoading = false;
      });
      // also, we will clear cart after success
      Provider.of<CartProvider>(context, listen: false).clearCart();
      pushNavigate(context, OrderSuccess());
      // from here, we will go to success opage
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print(error);
      getSnackbar(error.toString(), context);
    });
  }

  getCoupon() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        msg = null;
      });
      var coupon = await CouponApi().getCopon(t1.text);
      print(coupon);
      if (coupon == null) {
        setState(() {
          msg = 'Invalid coupon';
        });
        return;
      } else {
        if (coupon.endDate.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
          setState(() {
            msg = 'Coupon expired';
          });
          return;
        }
        if (coupon.usedById.contains(currentUser!.id)) {
          setState(() {
            msg = 'Coupon already used';
          });
          return;
        }
        if (coupon.minAmount >
            Provider.of<CartProvider>(context, listen: false)
                .getTotalAmount()) {
          setState(() {
            msg =
                'Minimum ${coupon.minAmount} purchase is required to use coupon';
          });
          return;
        }
      }
      // if all the checks are done, we can now apply the coupon
      setState(() {
        usecoupon = coupon;
        msg = 'Coupon Applied';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('User Details', context),
      bottomSheet: Container(
          // padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBoldText('Have a coupon?', Colors.black, 14),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 30,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: t1,
                                decoration: InputDecoration(
                                  label: getNormalText(
                                      'Coupon Code', Colors.black, 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          getButton('Apply', Colors.green, () {
                            getCoupon();
                          })
                        ],
                      ),
                      msg == null
                          ? Container()
                          : getNormalText(msg!, Colors.black, 14),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Net Amount:', MyColors.primaryColor, 17),
                          getNormalText(
                              '₹ ${Provider.of<CartProvider>(context, listen: false).getTotalAmount()}',
                              Colors.black,
                              17)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Delivery Charge:', Colors.black, 17),
                          getNormalText('₹ $deliveryCharge', Colors.black, 17)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      usecoupon == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getBoldText(
                                    'Coupon discount:', Colors.black, 17),
                                getNormalText('₹ ${usecoupon!.offAmount}',
                                    Colors.black, 17)
                              ],
                            ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText(
                              'Total Amount:', MyColors.primaryColor, 17),
                          getBoldText(
                              '₹ ${Provider.of<CartProvider>(context, listen: false).getTotalAmount() + deliveryCharge - (usecoupon == null ? 0 : usecoupon!.offAmount)}',
                              Colors.black,
                              17)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    addOrder();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    width: MediaQuery.of(context).size.width,
                    child: getBoldText('PLACE ORDER', Colors.white, 15),
                  ),
                )
              ],
            ),
          )),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: currentUser!.address.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddress = currentUser!.address[index];
                              });
                              getDeliveryCharge();
                            },
                            child: Card(
                              elevation:
                                  selectedAddress == currentUser!.address[index]
                                      ? 10
                                      : 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: selectedAddress ==
                                            currentUser!.address[index]
                                        ? Colors.blue
                                        : Colors.transparent,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getBoldText('Address:',
                                            MyColors.primaryColor, 15),
                                        getNormalText(
                                            currentUser!.address[index].address,
                                            Colors.black,
                                            14),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getBoldText(
                                            'Area:', MyColors.primaryColor, 15),
                                        getNormalText(
                                            currentUser!.address[index].area,
                                            Colors.black,
                                            14),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getBoldText('Landmark:',
                                            MyColors.primaryColor, 15),
                                        getNormalText(
                                            currentUser!
                                                .address[index].landmark,
                                            Colors.black,
                                            14),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          pushNavigate(context, UserDetailScreen());
                        },
                        child: getNormalText('Add Address', Colors.blue, 14),
                      ),
                      SizedBox(
                        height: 500,
                      )
                    ],
                  )),
            ),
    );
  }
}
