import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';
import 'package:mobilePlayGround1/ShoppingApp/screens/edit_products_screen.dart';
import 'package:provider/provider.dart';

class UserProductItems extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItems({Key key, this.id, this.title, this.imageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductsScreen.routeName, arguments: id);
              },
              color: Colors.greenAccent,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProducts(id);
                  } catch (error) {
                    scaffold.showSnackBar(
                        SnackBar(content: Text("Failed To Delete Product")));
                  }
                },
                color: Theme.of(context).errorColor)
          ],
        ),
      ),
    );
  }
}
