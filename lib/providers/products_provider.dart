import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-update-aa136.firebaseio.com/products.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        title: product.title,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://flutter-update-aa136.firebaseio.com/products/$id.json';
    final prodIndx = _items.indexWhere((element) => element.id == id);
    await http.patch(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    if (prodIndx >= 0) {
      _items[prodIndx] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update-aa136.firebaseio.com/products/$id.json';
    // index and product caching
    final productToDeleteIndex =
        _items.indexWhere((element) => element.id == id);
    var productToDelete = _items[productToDeleteIndex];

    // remove product locally
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    // send a delete request
    final response = await http.delete(url);
    // error
    if (response.statusCode >= 400) {
      _items.insert(
          productToDeleteIndex, productToDelete); // bring the item back
      notifyListeners();
      throw HttpException('Deleting failed:' + response.statusCode.toString());
    }

    productToDelete = null;
  }

  Future<void> fetchAndServeProducts() async {
    const url = 'https://flutter-update-aa136.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return;
      final List<Product> loadedProducts = [];
      data.forEach(
        (key, value) {
          final newProd = Product(
            description: value['description'],
            id: key,
            imageUrl: value['imageUrl'],
            price: value['price'],
            title: value['title'],
            isFavorite: value['isFavorite'],
          );
          loadedProducts.add(newProd);
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
