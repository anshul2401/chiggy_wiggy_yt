// import 'package:chiggy_wiggy/admin/screens/delivery_charge.dart';
// import 'package:chiggy_wiggy/helper/colors.dart';
// import 'package:chiggy_wiggy/helper/utils.dart';
// import 'package:flutter/material.dart';

// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             DrawerHeader(
//                 padding: EdgeInsets.zero,
//                 child: Container(
//                   alignment: Alignment.bottomLeft,
//                   decoration: BoxDecoration(
//                       color: MyColors.primaryColor,
//                       borderRadius:
//                           BorderRadius.only(bottomLeft: Radius.circular(20))),
//                   height: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: getNormalText('Hello Admin', Colors.white, 16),
//                   ),
//                 )),
//             ListTile(
//               leading: Icon(
//                 Icons.home,
//                 color: Colors.grey,
//               ),
//               title: getNormalText('Home', Colors.black, 16),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(
//                 Icons.money,
//                 color: Colors.grey,
//               ),
//               title: getNormalText('Delivery Charge', Colors.black, 16),
//               onTap: () {
//                 pushNavigate(context, DeliveryChargeScreen());
//               },
//             ),
//           ],
//         ),
//       ),
//       appBar: getOtherScreenAppBar('Orders', context),
//     );
//   }
// }
import 'package:chiggy_wiggy/admin/screens/add_banner.dart';
import 'package:chiggy_wiggy/admin/screens/admin_order_detail.dart';
import 'package:chiggy_wiggy/admin/screens/coupon_screen.dart';
import 'package:chiggy_wiggy/admin/screens/delivery_charge.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/order_model.dart';
import 'package:chiggy_wiggy/screens/home_screen.dart';
import 'package:chiggy_wiggy/screens/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String selectedTab = 'Pending';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: selectedTab)
        .where('date', isEqualTo: DateFormat('dd:MM:yy').format(selectedDate))
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: orderStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // print(snapshot.data!.docs.length);
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: getOtherScreenAppBar('Orders', context),
            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                            color: MyColors.primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20))),
                        height: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: getNormalText('Hello Admin', Colors.white, 16),
                        ),
                      )),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    title: getNormalText('Home', Colors.black, 16),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.money,
                      color: Colors.grey,
                    ),
                    title: getNormalText('Delivery Charge', Colors.black, 16),
                    onTap: () {
                      pushNavigate(context, DeliveryChargeScreen());
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.local_offer,
                      color: Colors.grey,
                    ),
                    title: getNormalText('Coupons', Colors.black, 16),
                    onTap: () {
                      pushNavigate(context, CouponScreen());
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.local_offer,
                      color: Colors.grey,
                    ),
                    title: getNormalText('Add banner', Colors.black, 16),
                    onTap: () {
                      pushNavigate(context, CouponScreen());
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                    title: getNormalText('Logout', Colors.black, 16),
                    onTap: () {
                      currentUser = null;
                      FirebaseAuth.instance.signOut();
                      pushAndRemoveNavigate(context, HomeScreen());
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: getLoading(),
            ),
          );
        }
        print(snapshot.data!.docs);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: Icon(Icons.calendar_month))
            ],
            toolbarHeight: 130,
            elevation: 0,
            title: Text('Orders'),
            flexibleSpace: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  color: MyColors.primaryColor,
                ),
                IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Pending';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedTab == 'Pending'
                                          ? MyColors.primaryColor
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: getNormalText(
                                        'Pending',
                                        selectedTab == 'Pending'
                                            ? Colors.white
                                            : Colors.black,
                                        14),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Cancelled';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedTab == 'Cancelled'
                                          ? MyColors.primaryColor
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: getNormalText(
                                        'Cancelled',
                                        selectedTab == 'Cancelled'
                                            ? Colors.white
                                            : Colors.black,
                                        14),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Completed';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedTab == 'Completed'
                                          ? MyColors.primaryColor
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: getNormalText(
                                        'Completed',
                                        selectedTab == 'Completed'
                                            ? Colors.white
                                            : Colors.black,
                                        14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    padding: EdgeInsets.zero,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          color: MyColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20))),
                      height: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: getNormalText('Hello Admin', Colors.white, 16),
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  title: getNormalText('Home', Colors.black, 16),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.money,
                    color: Colors.grey,
                  ),
                  title: getNormalText('Delivery Charge', Colors.black, 16),
                  onTap: () {
                    pushNavigate(context, DeliveryChargeScreen());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.local_offer,
                    color: Colors.grey,
                  ),
                  title: getNormalText('Coupons', Colors.black, 16),
                  onTap: () {
                    pushNavigate(context, CouponScreen());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.local_offer,
                    color: Colors.grey,
                  ),
                  title: getNormalText('Add banner', Colors.black, 16),
                  onTap: () {
                    pushNavigate(context, AddBanner());
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  title: getNormalText('Logout', Colors.black, 16),
                  onTap: () {
                    currentUser = null;
                    FirebaseAuth.instance.signOut();
                    pushAndRemoveNavigate(context, HomeScreen());
                  },
                ),
              ],
            ),
          ),
          body: snapshot.data!.docs.isEmpty
              ? Center(
                  child: getNormalText('No Orders here', Colors.black, 14),
                )
              : ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    OrderModel order = OrderModel.fromJson(data);
                    print(data);
                    return GestureDetector(
                      onTap: () {
                        pushNavigate(
                            context,
                            AdminOrderDetail(
                              order: order,
                              id: document.id,
                            ));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getBoldText(
                                  DateFormat('dd MMMM yy, HH:mm')
                                      .format(order.dateTime),
                                  MyColors.primaryColor,
                                  16),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: order.items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          height: 30,
                                          width: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                                fit: BoxFit.fill,
                                                order.items[index].productModel!
                                                    .imgUrl),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        getNormalText(
                                            '${order.items[index].productModel!.name} x ${order.items[index].qty}',
                                            Colors.black,
                                            14),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: getBoldText(
                                    'TOTAL: ₹ ${order.totalAmount}',
                                    Colors.black,
                                    15),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}
