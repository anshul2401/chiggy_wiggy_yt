import 'package:chiggy_wiggy/admin/api/order_api.dart/order_api.dart';
import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminOrderDetail extends StatefulWidget {
  final OrderModel order;
  final String id;
  const AdminOrderDetail({super.key, required this.order, required this.id});

  @override
  State<AdminOrderDetail> createState() => _AdminOrderDetailState();
}

class _AdminOrderDetailState extends State<AdminOrderDetail> {
  showAlertDialog(BuildContext context, String status) {
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
        cancelOrder(status);
      },
    );

    // set up the AlertDialog
    AlertDialog alert2 = AlertDialog(
      title: Text("Complete the order?"),
      content: Text("Is Order delivered?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
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
        return status == 'Cancelled' ? alert : alert2;
      },
    );
  }

  cancelOrder(String status) {
    setState(() {
      isLoading = true;
    });
    OrderApi().updateOrder(widget.id, status).then((value) {
      setState(() {
        isLoading = false;
      });

      getSnackbar('Order ${status}', context);
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackbar(error.toString(), context);
    });
  }

  bool isLoading = false;
  // static Future<void> openMap(double latitude, double longitude) async {
  //   String googleUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  //   await launchUrl(Uri.parse(googleUrl));
  // }
  static Future<void> openMap(double latitude, double longitude) async {
    MapsLauncher.launchCoordinates(latitude, longitude);
  }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getNormalText(
                                widget.order.phoneNumber, Colors.black, 14),
                            getButton('Call now', Colors.green, () {
                              launchUrl(Uri.parse(
                                  'tel://${widget.order.phoneNumber}'));
                            })
                          ],
                        ),
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
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getButton('Cancel Order', Colors.red, () {
                                    showAlertDialog(context, 'Cancelled');
                                  }),
                                  getButton('Delivered', Colors.green, () {
                                    showAlertDialog(context, 'Completed');
                                  })
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: getButton('Open in map', Colors.blue, () {
                            openMap(double.parse(widget.order.address.latitude),
                                double.parse(widget.order.address.longitude));
                          }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
