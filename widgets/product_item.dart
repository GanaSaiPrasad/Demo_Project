import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/cart.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/product.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/user_auth.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/products_details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageurl;

  // const ProductItem({
  //  Key key,
  //  this.title,
  //  this.imageurl,
  //  this.id,
  // }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
    );

    final cart = Provider.of<Cart>(
      context,
    );

    final userAuth = Provider.of<UserAuth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => {
          Navigator.of(context)
              .pushNamed(ProductsDetailsScreen.routename, arguments: product.id)
        },
        child: GridTile(
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/fonts/images/product-placeholder.png'),
                image: NetworkImage(
                  product.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    product.toggleFavoriteStatus(
                        userAuth.token, userAuth.userId);
                  }),
              title: Text(product.title, textAlign: TextAlign.center),
              trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  cart.addCartItems(product.id, product.title, product.price);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Items Added to Cart"),
                    duration: Duration(seconds: 3),
                    action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                },
              ),
            )),
      ),
    );
  }
}
