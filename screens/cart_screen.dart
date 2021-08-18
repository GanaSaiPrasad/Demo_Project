import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/cart.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/orders.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/orders_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/cart_items.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
    );
    final order = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(children: <Widget>[
        Card(
          color: Colors.greenAccent,
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Total",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 15,
                ),
                Spacer(),
                Chip(
                  label: Text(
                    "\$${cart.totalAmount}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                OrderButton(
                  cart: cart,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: cart.cartItems.values.toList()[index],
              child: CartItems(
                  //   id: cart.cartItems.values.toList()[index].id,
                  //    title: cart.cartItems.values.toList()[index].title,
                  //    price: cart.cartItems.values.toList()[index].price,
                  //     quantity: cart.cartItems.values.toList()[index].quantity,
                  productId: cart.cartItems.keys.toList()[index])),
          itemCount: cart.itemCount,
        ))
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    //  @required this.order,
  }) : super(key: key);

  final Cart cart;
  //final Orders order;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: widget.cart.totalAmount <= 0 || _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.cartItems.values.toList(),
                    widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });

                widget.cart.clearCart();
                // Navigator.of(context).pushNamed(OrdersScreen.routeName);
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                "Place Order",
                style: TextStyle(fontSize: 18),
              ));
  }
}
