import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

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
  void setFilter(FavsFilter filter) {
    setState(() {
      if (filter == FavsFilter.Favorite)
        _showFavs = true;
      else
        _showFavs = false;
    });
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
          )
        ],
      ),
      body: ProductsGrid(_showFavs),
    );
  }
}
