import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/edit_products_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/app-drawer.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/user_product_items.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final userProducts = Provider.of<Products>(
    //  context,
    //  );
    return Scaffold(
      appBar: AppBar(
        title: Text("User Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Consumer<Products>(
                      builder: (context, userProducts, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (context, index) => Column(
                            children: [
                              UserProductItems(
                                  id: userProducts.productItems[index].id,
                                  title: userProducts.productItems[index].title,
                                  imageUrl: userProducts
                                      .productItems[index].imageUrl),
                              Divider(
                                thickness: 4,
                              )
                            ],
                          ),
                          itemCount: userProducts.productItems.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
