import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_providers.dart';
import '../providers/product.dart';

// ignore: use_key_in_widget_constructors
class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProducts';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _focusPriceNode = FocusNode();
  final _focusDescNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _focusImageNode = FocusNode();
  var _editedProducted =
      Product(id: "", title: "", description: "", price: 0.0, imageUrl: "");
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _focusImageNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      // ignore: unnecessary_null_comparison
      if (productId != null && productId.isNotEmpty) {
        _editedProducted =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProducted.title,
          'description': _editedProducted.description,
          'price': _editedProducted.price.toString(),
          'imageUrl': '',
        };
        _imageController.text = _editedProducted.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // to avoid memory leaks we need to dispose the nodes
    _focusImageNode.removeListener(_updateImageUrl);
    _focusPriceNode.dispose();
    _focusDescNode.dispose();
    _focusImageNode.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_focusImageNode.hasFocus) {
      setState(() {
        if (!_imageController.text.startsWith('http') &&
            !_imageController.text.startsWith('https') &&
            !_imageController.text.endsWith('.png') &&
            !_imageController.text.endsWith('.jpg') &&
            !_imageController.text.endsWith('.jpeg')) {
          return;
        }
      });
    }
  }

  Future<void> _saveForm() async {
    final boole = _form.currentState!.validate();
    if (!boole) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProducted.id.isEmpty) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProducted);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An Error Occured'),
                  content: const Text('Something Went Wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Okay'))
                  ],
                ));
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProducted.id, _editedProducted);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_focusPriceNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Provide a value';
                          }
                          return null;
                        },
                        onSaved: ((newValue) {
                          _editedProducted = Product(
                              id: _editedProducted.id,
                              description: _editedProducted.description,
                              imageUrl: _editedProducted.imageUrl,
                              price: _editedProducted.price,
                              isFavourite: _editedProducted.isFavourite,
                              title: newValue.toString());
                        }),
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],

                        // decoration: const InputDecoration(labelText: 'Price'),
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a Price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a Valid Number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter a Value Greater Than 0';
                          }
                          return null;
                        },
                        focusNode: _focusPriceNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_focusDescNode);
                        },
                        onSaved: ((newValue) {
                          _editedProducted = Product(
                              id: _editedProducted.id,
                              description: _editedProducted.description,
                              imageUrl: _editedProducted.imageUrl,
                              isFavourite: _editedProducted.isFavourite,
                              price: double.parse(newValue.toString()),
                              title: _editedProducted.title);
                        }),
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _focusDescNode,
                        // ignore: body_might_complete_normally_nullable
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return 'Enter a Description';
                          }
                          if (value.length < 10) {
                            return 'Description must contain minimum 10 characters';
                          }
                        }),
                        onSaved: ((newValue) {
                          _editedProducted = Product(
                              id: _editedProducted.id,
                              description: newValue.toString(),
                              imageUrl: _editedProducted.imageUrl,
                              isFavourite: _editedProducted.isFavourite,
                              price: _editedProducted.price,
                              title: _editedProducted.title);
                        }),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 10, left: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.blue,
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: _imageController.text.isEmpty
                                  ? const Text(
                                      'ENTER A URL',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                        _imageController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _focusImageNode,
                              controller: _imageController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter a Image URL';
                                }

                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: ((newValue) {
                                _editedProducted = Product(
                                    id: _editedProducted.id,
                                    description: _editedProducted.description,
                                    isFavourite: _editedProducted.isFavourite,
                                    imageUrl: newValue.toString(),
                                    price: _editedProducted.price,
                                    title: _editedProducted.title);
                              }),
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
