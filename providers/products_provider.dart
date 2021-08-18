import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilePlayGround1/ShoppingApp/models/http_exception.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/product.dart';

import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _productItems = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  //bool _showFavoritesOnly = false;

  final String userToken;
  final String userId;

  Products(this.userToken, this.userId, this._productItems);

  List<Product> get productItems {
    //if (_showFavoritesOnly) {
    //  return _productItems.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._productItems];
  }

  List<Product> get favoriteItems {
    return _productItems.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return productItems.firstWhere((prod) => prod.id == id);
  }

  //void showFavorites() {
  //  _showFavoritesOnly = true;
  // notifyListeners();
  //}

  // void showAll() {
  ///  _showFavoritesOnly = false;
//notifyListeners();
  //}

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final prodIndex = _productItems.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopapp-1-11ac8-default-rtdb.firebaseio.com/Products/$id.json?auth=$userToken';

      await http.patch(url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'imageUrl': updatedProduct.imageUrl,
            'price': updatedProduct.price,
          }));
      _productItems[prodIndex] = updatedProduct;
    } else {
      print('....');
    }
    notifyListeners();
  }

  Future<void> getProducts([bool filterUserProducts = false]) async {
    final filterProducts =
        filterUserProducts ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url1 =
        'https://shopapp-1-11ac8-default-rtdb.firebaseio.com/Products.json?auth=$userToken&$filterProducts';
    try {
      final response = await http.get(url1);

      print(json.decode(response.body));
      //  print(response);

      final userProducts = json.decode(response.body) as Map<String, dynamic>;
      if (userProducts == null || userProducts['error'] != null) {
        return;
      }
      url1 =
          "https://shopapp-1-11ac8-default-rtdb.firebaseio.com/UserFavourites/$userId.json?auth=$userToken";
      final favouriteStatusResponse = await http.get(url1);
      final favouriteStatus = json.decode(favouriteStatusResponse.body);
      final List<Product> loadedProducts = [];
      userProducts.forEach((userProdId, userProdData) {
        loadedProducts.add(Product(
          id: userProdId,
          title: userProdData['title'],
          description: userProdData['description'],
          price: userProdData['price'],
          imageUrl: userProdData['imageUrl'],
          isFavorite: favouriteStatus == null
              ? false
              : favouriteStatus[userProdId] ?? false,
          //   userToken: userToken
        ));
      });

      _productItems = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Product product) async {
    final url =
        'https://shopapp-1-11ac8-default-rtdb.firebaseio.com/Products.json?auth=$userToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'userId': userId
          // 'isFavorite': product.isFavorite
        }),
      );

      print(json.decode(response.body));
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'],
          isFavorite: product.isFavorite);

      _productItems.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProducts(String id) async {
    final url =
        'https://shopapp-1-11ac8-default-rtdb.firebaseio.com/Products/$id.json?auth=$userToken';
    final existingProductIndex =
        _productItems.indexWhere((prod) => prod.id == id);
    var existingProduct = _productItems[existingProductIndex];

    _productItems.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _productItems.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Http_Exception('Unable To Delete Product');
    }
    existingProduct = null;
  }
}
