import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/const.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/order_model.dart';
import 'package:chiggy_wiggy/screens/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserOrderScreen extends StatefulWidget {
  const UserOrderScreen({super.key});

  @override
  State<UserOrderScreen> createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {
  String selectedTab = 'Pending';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: currentUser!.id)
        .where('status', isEqualTo: selectedTab)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _orderStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: getOtherScreenAppBar('Orders', context),
            body: Center(
              child: getLoading(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
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
          body: snapshot.data!.docs.length == 0
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
                    return GestureDetector(
                      onTap: () {
                        pushNavigate(
                            context,
                            OrderDetails(
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
