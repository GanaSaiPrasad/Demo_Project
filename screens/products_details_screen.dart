import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductsDetailsScreen extends StatefulWidget {
  static const routename = '/product_details';

  @override
  _ProductsDetailsScreenState createState() => _ProductsDetailsScreenState();
}

class _ProductsDetailsScreenState extends State<ProductsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProducts =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProducts.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                tag: loadedProducts.id,
                child: Image.network(
                  loadedProducts.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedProducts.price}',
                style: TextStyle(color: Colors.blueGrey, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProducts.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
        // CustomScrollView(
        //   slivers: <Widget>[
        //     SliverAppBar(
        //       expandedHeight: 300,
        //       pinned: true,
        //       flexibleSpace: FlexibleSpaceBar(
        //         title: Text(loadedProducts.title),
        //         background: Hero(
        //           tag: loadedProducts.id,
        //           child: Image.network(
        //             loadedProducts.imageUrl,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //     ),
        // SliverList(
        //     delegate: SliverChildListDelegate([
        //   SizedBox(
        //     height: 10,
        //   ),
        //   Text(
        //     '\$${loadedProducts.price}',
        //     style: TextStyle(color: Colors.blueGrey, fontSize: 20),
        //   ),
        //   SizedBox(
        //     height: 10,
        //   ),
        //   Container(
        //     padding: EdgeInsets.symmetric(horizontal: 10),
        //     child: Text(
        //       loadedProducts.description,
        //       softWrap: true,
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        //   SizedBox(
        //     height: 800,
        //   )
        // ]))

        );
  }
}
