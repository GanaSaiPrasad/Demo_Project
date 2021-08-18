import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/user_auth.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/user_login_service.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/orders_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_login_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              // Navigator.of(context)
              //   .pushReplacementNamed(UserLoginScreen.routeName);
              Provider.of<UserAuth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
