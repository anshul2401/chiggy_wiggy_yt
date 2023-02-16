import 'package:chiggy_wiggy/admin/screens/add_delivery_charge.dart';
import 'package:chiggy_wiggy/admin/screens/update_delivery_charge.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeliveryChargeScreen extends StatefulWidget {
  const DeliveryChargeScreen({super.key});

  @override
  State<DeliveryChargeScreen> createState() => _DeliveryChargeScreenState();
}

class _DeliveryChargeScreenState extends State<DeliveryChargeScreen> {
  final Stream<QuerySnapshot> _deliveryChargeStream =
      FirebaseFirestore.instance.collection('delivery_charges').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _deliveryChargeStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: getOtherScreenAppBar('Delivery Charge', context),
            body: getLoading(),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pushNavigate(context, AddDeliveryCharge());
            },
            child: Icon(Icons.add),
          ),
          appBar: getOtherScreenAppBar('Delivery Charge', context),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        getNormalText(data['name'], Colors.black, 14),
                        Spacer(),
                        getBoldText(
                            '₹ ${data['deliveryCharge']}', Colors.black, 14),
                        IconButton(
                            onPressed: () {
                              pushNavigate(
                                  context,
                                  UpdateDeliveryCharge(
                                      data: data, id: document.id));
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// Scaffold(
//       appBar: getOtherScreenAppBar('Delivery Charges', context),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           pushNavigate(context, AddDeliveryCharge());
//         },
//         child: Icon(Icons.add),
//       ),
//     );