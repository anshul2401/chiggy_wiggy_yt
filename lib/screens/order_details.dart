import 'package:chiggy_wiggy/admin/api/order_api.dart/order_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel order;
  final String id;
  const OrderDetails({super.key, required this.order, required this.id});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        cancelOrder();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancel the order?"),
      content: Text("Are you sure you want to cancel the order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  cancelOrder() {
    setState(() {
      isLoading = true;
    });
    OrderApi().updateOrder(widget.id, 'Cancelled').then((value) {
      setState(() {
        isLoading = false;
      });
      getSnackbar('Order Cancelled', context);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackbar(error.toString(), context);
    });
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Order details', context),
      body: isLoading
          ? getLoading()
          : Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getBoldText('# ORDER DETAILS', Colors.black, 16),
                        Divider(),
                        getBoldText(
                            DateFormat('dd MMMM yy, HH:mm')
                                .format(widget.order.dateTime),
                            MyColors.primaryColor,
                            16),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.order.items.length,
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
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                          fit: BoxFit.fill,
                                          widget.order.items[index]
                                              .productModel!.imgUrl),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  getNormalText(
                                      '${widget.order.items[index].productModel!.name} x ${widget.order.items[index].qty}',
                                      Colors.black,
                                      14),
                                  Spacer(),
                                  getBoldText(
                                      '₹ ${int.parse((widget.order.items[index].productModel!.price)) * (widget.order.items[index].qty!)}',
                                      Colors.black,
                                      15)
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: getBoldText(
                              'TOTAL: ₹ ${widget.order.totalAmount}',
                              Colors.black,
                              15),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getBoldText('# DELIVERY DETAILS', Colors.black, 16),
                        Divider(),
                        getNormalText(widget.order.name, Colors.black, 14),
                        getNormalText(
                            widget.order.phoneNumber, Colors.black, 14),
                        getNormalText(
                            widget.order.address.address, Colors.black, 14),
                        getNormalText(
                            widget.order.address.area, Colors.black, 14),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getBoldText('# DELIVERY STATUS', Colors.black, 16),
                        Divider(),
                        getBoldText(
                            widget.order.status,
                            widget.order.status == 'Pending'
                                ? Colors.yellow
                                : widget.order.status == 'Cancelled'
                                    ? Colors.red
                                    : Colors.green,
                            18),
                        SizedBox(
                          height: 10,
                        ),
                        widget.order.status == 'Pending'
                            ? getButton('Cancel Order', Colors.red, () {
                                showAlertDialog(context);
                              })
                            : Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
