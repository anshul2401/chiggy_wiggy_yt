import 'package:chiggy_wiggy/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get cartItem => _cartItems;

  // ADD TO CART FUNCTION

  void addToCart(CartModel cartItem, bool isIncrease) {
    // if cart already contain our cart item
    if (_cartItems.containsKey(cartItem.productModel!.name)) {
      _cartItems.update(
          cartItem.productModel!.name,
          (value) => CartModel(
              id: value.id,
              productModel: value.productModel,
              qty: isIncrease ? value.qty! + 1 : value.qty! - 1));
    } else {
      _cartItems.putIfAbsent(cartItem.productModel!.name, () => cartItem);
      print('added ');
    }
    notifyListeners();
  }

  // TOTAL CART ITEM FUNCTION

  int totalCartItem() {
    return _cartItems.length;
  }

  // QUANTITY OF A CART ITEM

  int cartItemQty(String name) {
    return _cartItems.containsKey(name) ? _cartItems[name]!.qty! : 0;
    // we pass name here because our unque identifier is name of the product
  }

  removeFromCart(String name) {
    _cartItems.remove(name);
    notifyListeners();
  }

  // CLEAR THE CART

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Total Amount
  int getTotalAmount() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += int.parse(value.productModel!.price) * value.qty!;
    });
    return total;
  }
}
