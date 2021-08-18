import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/cart.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get orderItem {
    return [..._orderItems];
  }

  final String userToken;
  final String userId;
  Orders(this.userToken, this.userId, this._orderItems);

  Future<void> getOrders() async {
    final url =
        "https://shopapp-1-11ac8-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$userToken";

    final response = await http.get(url);

    final List<OrderItem> loadedOrders = [];
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;

    if (extractedOrders == null) {
      return;
    }
    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          datetime: DateTime.parse(orderData["datetime"]),
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (cartItems) => CartItem(
                    id: cartItems['id'],
                    price: cartItems['price'],
                    title: cartItems['title'],
                    quantity: cartItems['quantity']),
              )
              .toList(),
        ),
      );
    });
    _orderItems = loadedOrders.reversed.toList();
    notifyListeners();
    // print(json.decode(response.body));
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // final dateTimeStamp = DateTime.now();
    final url =
        "https://shopapp-1-11ac8-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$userToken";
    final dateTimeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "datetime": dateTimeStamp.toIso8601String(),
          "products": (cartProducts.map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price
              })).toList()
        }));
    _orderItems.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            datetime: dateTimeStamp));
    notifyListeners();
  }
}
