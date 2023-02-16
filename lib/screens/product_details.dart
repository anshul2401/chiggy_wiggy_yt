import 'package:chiggy_wiggy/helper/colors.dart';
import 'package:chiggy_wiggy/helper/utils.dart';
import 'package:chiggy_wiggy/models/product_model.dart';
import 'package:chiggy_wiggy/providers/cart_provider.dart';
import 'package:chiggy_wiggy/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

class ProductDetail extends StatefulWidget {
  ProductModel productModel;
  ProductDetail({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<ProductModel> products = [
    ProductModel(
        name: 'Chicken curry',
        description:
            'Get the finest chicken curry available in the market with the lowest price, Get the finest chicken curry available in the market with the lowest price Get the finest chicken curry available in the market with the lowest price Get the finest chicken curry available in the market with the lowest price Get the finest chicken curry available in the market with the lowest price Get the finest chicken curry available in the market with the lowest price',
        price: '100',
        shortDescription: 'Best chicken curry in the world',
        weight: '500',
        imgUrl: 'assets/images/chicken.jpg',
        category: 'Chicken',
        isAvailable: true),
    ProductModel(
        name: 'Chicken curry',
        description:
            'Get the finest chicken curry available in the market with the lowest price',
        price: '100',
        shortDescription: 'Best chicken curry in the world',
        weight: '500',
        imgUrl: 'assets/images/chicken.jpg',
        category: 'Chicken',
        isAvailable: true),
    ProductModel(
        name: 'Chicken curry',
        description:
            'Get the finest chicken curry available in the market with the lowest price',
        price: '100',
        shortDescription: 'Best chicken curry in the world',
        weight: '500',
        imgUrl: 'assets/images/chicken.jpg',
        category: 'Chicken',
        isAvailable: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: GestureDetector(
        onTap: () {
          pushNavigate(context, CartScreen());
        },
        child: Container(
            alignment: Alignment.center,
            width: getTotalWidth(context),
            height: 50,
            color: Colors.red,
            child: getBoldText('GO TO CART', Colors.white, 16)),
      ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          flexibleSpace: FlexibleSpaceBar(
            title: getBoldText(widget.productModel.name, Colors.white, 18),
            background: Image.network(
              widget.productModel.imgUrl,
              fit: BoxFit.fill,
            ),
            centerTitle: false,
          ),
          pinned: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border))
          ],
          expandedHeight: getTotalHeight(context) / 3,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Provider.of<CartProvider>(context)
                                  .cartItemQty(widget.productModel.name) ==
                              0
                          ? GestureDetector(
                              onTap: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addToCart(
                                        CartModel(
                                            id: widget.productModel.name,
                                            productModel: widget.productModel,
                                            qty: 1),
                                        true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: MyColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: getNormalText('ADD +', Colors.white, 16),
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
                                                  id: widget.productModel.name,
                                                  productModel:
                                                      widget.productModel,
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
                                            .cartItemQty(
                                                widget.productModel.name)
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
                                                  id: widget.productModel.name,
                                                  productModel:
                                                      widget.productModel,
                                                  qty: 1),
                                              false);
                                      if (Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .cartItemQty(
                                                  widget.productModel.name) ==
                                          0) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCart(
                                                widget.productModel.name);
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
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getBoldText('Price: ₹' + widget.productModel.price,
                          Colors.black, 18),
                      getNormalText(
                          widget.productModel.weight + 'gm', Colors.black, 18),
                    ],
                  ),
                ),
                Divider(),
                getNormalText(
                    widget.productModel.description, Colors.black, 16),
                SizedBox(
                  height: 20,
                ),
                // getBoldText('You may also like', Colors.black, 18),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: products.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     return getProductCard(products[index]);
                //   },
                // ),
              ],
            ),
          )
        ]))
      ]),
    );
  }

  getProductCard(ProductModel productModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(productModel.imgUrl),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getNormalText(productModel.name, Colors.black, 16),
                      getNormalText('₹ ${productModel.price}', Colors.grey, 14)
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: getNormalText('ADD +', Colors.white, 16),
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
