import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';

enum FavsFilter {
  All,
  Favorite,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavs = false;
  var _isLoading = false;

  void setFilter(FavsFilter filter) {
    setState(() {
      if (filter == FavsFilter.Favorite)
        _showFavs = true;
      else
        _showFavs = false;
    });
  }

  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSerProducts();
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration.zero).then((_) {
      // Sort of a workaround
      Provider.of<Products>(context, listen: false)
          .fetchAndServeProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (value) => setFilter(value),
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Show All'),
                value: FavsFilter.All,
              ),
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: FavsFilter.Favorite,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, ch) => Badge(
              value: cartData.itemCount.toString(),
              child: ch,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavs),
    );
  }
}
