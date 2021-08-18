import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/cart.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/cart_screen.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/app-drawer.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/badge.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/product_overview_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { OnlyFavorites, AllProducts }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/overview_screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;

  var isInit = true;

  var isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then(
    //     (_) => Provider.of<Products>(context, listen: false).getProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false).getProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping App'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.OnlyFavorites) {
                  //  productsContainer.showFavorites();
                  _showFavoritesOnly = true;
                } else {
                  // productsContainer.showAll();

                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(" Only Favorites"),
                value: FilterOptions.OnlyFavorites,
              ),
              PopupMenuItem(
                child: Text(
                  " Show All Products",
                ),
                value: FilterOptions.AllProducts,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, ch) =>
                Badge(child: ch, value: cartData.itemCount.toString()),
            child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavs: _showFavoritesOnly),
    );
  }
}
