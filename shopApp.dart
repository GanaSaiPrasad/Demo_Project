import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/auth.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/user_auth.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/user_login_service.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/auth_screen_example.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/splash_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_login_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_register_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/cart.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/orders.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/cart_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/edit_products_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/orders_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import 'package:mobilePlayGround1/ShoppingApp/screens/products_details_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/products_overview_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (BuildContext context) => UserAuth()),
          ChangeNotifierProvider(
              create: (BuildContext context) => UserAuthorization()),
          ChangeNotifierProvider(
              create: (BuildContext context) => LoginAuthorization()),
          ChangeNotifierProxyProvider<UserAuth, Products>(
              create: (_) => Products('', '', []),
              update: (context, auth, previousproducts) => Products(
                  auth.token,
                  auth.userId,
                  previousproducts.productItems == null
                      ? []
                      : previousproducts.productItems)),
          ChangeNotifierProvider(create: (BuildContext context) => Cart()),
          ChangeNotifierProxyProvider<UserAuth, Orders>(
              create: (_) => Orders('', '', []),
              update: (context, auth, previousOrders) => Orders(
                  auth.token,
                  auth.userId,
                  previousOrders.orderItem == null
                      ? []
                      : previousOrders.orderItem)),
        ],
        child: Consumer<UserAuth>(
          builder: (context, authorization, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'Anton',
                primaryColor: Colors.purple,
                accentColor: Colors.red),
            home: authorization.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authorization.autoLogin(),
                    builder: (context, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            // : UserLoginScreen(),
            routes: {
              //  AuthScreen.routeName: (context) => AuthScreen(),
              // UserLoginScreen.routeName: (context) => UserLoginScreen(),
              //UserRegisterScreen.routeName: (context) => UserRegisterScreen(),
              ProductsOverviewScreen.routeName: (context) =>
                  ProductsOverviewScreen(),
              ProductsDetailsScreen.routename: (context) =>
                  ProductsDetailsScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductsScreen.routeName: (context) => EditProductsScreen()
            },
          ),
        ));
  }
}
