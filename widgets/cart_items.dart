import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItems extends StatelessWidget {
//  final String id;
  // final String title;
  // final double price;
  // final int quantity;
  final String productId;

  const CartItems({Key key, this.productId}) : super(key: key);

  /// const CartItems({Key key, this.id, this.title, this.price, this.quantity})
//: super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartItem>(
      context,
    );
    final cartItem = Provider.of<Cart>(
      context,
    );

    return Dismissible(
      key: ValueKey(cartItems.id),
      background: Container(
        color: Colors.yellow,
        child: Icon(
          Icons.delete,
          size: 35,
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Are You Sure You Want to Remove Item From the Cart'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No"))
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cartItem.removeCartItems(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading:
                CircleAvatar(radius: 30, child: Text('\$${cartItems.price}')),
            title: Text('${cartItems.title}'),
            subtitle:
                Text('Total  \$${(cartItems.price * cartItems.quantity)}'),
            trailing: Text('${(cartItems.quantity)}  x'),
          ),
        ),
      ),
    );
  }
}
