import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';
import 'package:mobilePlayGround1/ShoppingApp/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  const ProductsGrid({Key key, this.showFavs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.favoriteItems : productsData.productItems;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              //  id: productsData[index].id,
              //  title: productsData[index].title,
              //  imageurl: productsData[index].imageUrl,
              )),
      padding: EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}
