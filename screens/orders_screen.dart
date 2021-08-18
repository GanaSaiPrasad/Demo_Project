import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/orders.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/app-drawer.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders_screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future orders;
  Future obtainedOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrders();
  }

  //var _isLoading = false;
  @override
  void initState() {
    orders = obtainedOrdersFuture();
    // Future.delayed(Duration.zero).then((_) async {
    // setState(() {
    // _isLoading = true;
    // // });

    // // await
    // Provider.of<Orders>(context, listen: false).getOrders().then((_) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    //  });
    super.initState();
  }

  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context, listen: false);

    //final orderItems = orderData.orderItem;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            //   else if(snapshot.hasError!=null){
            ///
            //   }

            else {
              return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                        itemBuilder: (context, index) =>
                            OrderItems(orderItem: orderData.orderItem[index]),
                        itemCount: orderData.orderItem.length,
                      ));
            }
          },
          future: orders),
      //  _isLoading
      // ? Center(child: CircularProgressIndicator())
      //    : ListView.builder(
      //   itemBuilder: (context, index) =>
      //      OrderItems(orderItem: orderItems[index]),
      //  itemCount: orderItems.length,
      // ),
    );
  }
}
