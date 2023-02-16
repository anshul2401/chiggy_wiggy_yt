import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/cart_model.dart';
import 'package:chiggy_wiggy/models/product_model.dart';
import 'package:chiggy_wiggy/providers/cart_provider.dart';
import 'package:chiggy_wiggy/screens/cart_screen.dart';
import 'package:chiggy_wiggy/screens/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  final String title;
  const ProductList({Key? key, required this.title}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String? title;
  Stream<QuerySnapshot>? _productStream;
  @override
  void initState() {
    title = widget.title;
    _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.title)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: getOtherScreenAppBar('Products', context),
              body: getLoading());
        }
        //first lets put a cart icon on the nav bar
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () {
                    pushNavigate(context, CartScreen());
                  },
                  icon: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart),
                      ),
                      Provider.of<CartProvider>(context).totalCartItem() == 0
                          ? Container(
                              height: 0,
                            )
                          : Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: getNormalText(
                                  Provider.of<CartProvider>(context)
                                      .totalCartItem()
                                      .toString(),
                                  MyColors.primaryColor,
                                  12),
                            ),
                    ],
                  ))
            ],
            //we have to show number of items in cart on badge on the top of our icon
            flexibleSpace: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  color: MyColors.primaryColor,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  height: 20,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                ProductModel product = ProductModel.fromJson(data);
                return getProductCard(product);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  //second and most important thing is to filter our data, which is very easy

  Widget getProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        product.isAvailable
            ? pushNavigate(context, ProductDetail(productModel: product))
            : getSnackbar('Out of stock', context);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: getTotalWidth(context),
              height: getTotalHeight(context) / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  product.imgUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getBoldText(product.name, Colors.black, 18),
                  SizedBox(
                    height: 10,
                  ),
                  getNormalText(product.shortDescription, Colors.black, 16),
                  SizedBox(
                    height: 10,
                  ),
                  getNormalText('${product.weight} gms', Colors.grey, 16),
                  SizedBox(
                    height: 10,
                  ),
                  // now, if a product is already present in cart, we have to show some other widget.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getBoldText('₹ ${product.price}', Colors.black, 20),
                      // we will check the qty of the product in cart
                      //perfect, lets design the widget to increase or dec the qty of itme
                      product.isAvailable
                          ? Provider.of<CartProvider>(context)
                                      .cartItemQty(product.name) ==
                                  0
                              ? GestureDetector(
                                  onTap: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .addToCart(
                                            CartModel(
                                                id: product.name,
                                                productModel: product,
                                                qty: 1),
                                            true);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: MyColors.primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: getNormalText(
                                        'ADD +', Colors.white, 16),
                                  ),
                                )
                              : Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // increase the qty
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addToCart(
                                                  CartModel(
                                                      id: product.name,
                                                      productModel: product,
                                                      qty: 1),
                                                  true);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: MyColors.primaryColor
                                                  .withOpacity(0.2)),
                                          child: Icon(
                                            Icons.add,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: getBoldText(
                                            Provider.of<CartProvider>(context)
                                                .cartItemQty(product.name)
                                                .toString(),
                                            Colors.black,
                                            15),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addToCart(
                                                  CartModel(
                                                      id: product.name,
                                                      productModel: product,
                                                      qty: 1),
                                                  false);
                                          if (Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .cartItemQty(product.name) ==
                                              0) {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .removeFromCart(product.name);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: MyColors.primaryColor
                                                  .withOpacity(0.2)),
                                          child: Icon(
                                            Icons.remove,
                                            color: MyColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                          : getNormalText('Out of stock', Colors.red, 14)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
