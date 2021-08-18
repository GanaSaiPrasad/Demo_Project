import 'package:flutter/material.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/product.dart';
import 'package:mobilePlayGround1/ShoppingApp/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  var _editedProducts = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;

  var isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProducts =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProducts.title,
          'description': _editedProducts.description,
          'price': _editedProducts.price.toString(),
          // 'imageUrl': _editedProducts.imageUrl

          'imageUrl': ''
        };
        _imageUrlController.text = _editedProducts.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _savaForm() async {
    _formKey.currentState.validate();

    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedProducts.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProducts.id, _editedProducts);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProducts);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('An Error Occured'),
                content: Text('Something Went Wrong'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay"))
                ],
              );
            });
      } //finally {
      //  setState(() {
      //    isLoading = false;
      //  });

      //  Navigator.of(context).pop();
      // }

    }
    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.save,
              ),
              onPressed: _savaForm)
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: initValues['title'],
                        decoration: InputDecoration(labelText: "Product Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Title Cannot Be Empty";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProducts = Product(
                              title: value,
                              description: _editedProducts.description,
                              price: _editedProducts.price,
                              imageUrl: _editedProducts.imageUrl,
                              id: _editedProducts.id,
                              isFavorite: _editedProducts.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['price'],
                        decoration: InputDecoration(labelText: "Product Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please Enter Valid Price Value";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please Enter Valid Price";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProducts = Product(
                              title: _editedProducts.title,
                              description: _editedProducts.description,
                              price: double.parse(value),
                              imageUrl: _editedProducts.imageUrl,
                              id: _editedProducts.id,
                              isFavorite: _editedProducts.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: initValues['description'],
                        decoration:
                            InputDecoration(labelText: "Product Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Description";
                          } else if (value.length < 10) {
                            return " Description Should Be Atleast 10 Characters";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _editedProducts = Product(
                              title: _editedProducts.title,
                              description: value,
                              price: _editedProducts.price,
                              imageUrl: _editedProducts.imageUrl,
                              id: _editedProducts.id,
                              isFavorite: _editedProducts.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 12, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.tealAccent)),
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter URL")
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: initValues['imageUrl'],
                              decoration:
                                  InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _savaForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter URL";
                                }

                                if (value.startsWith('http') ||
                                    value.startsWith('https')) {
                                  return null;
                                }
                                return "Please Enter Valid URL";
                              },
                              onSaved: (value) {
                                _editedProducts = Product(
                                    title: _editedProducts.title,
                                    description: _editedProducts.description,
                                    price: _editedProducts.price,
                                    imageUrl: value,
                                    id: _editedProducts.id,
                                    isFavorite: _editedProducts.isFavorite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
