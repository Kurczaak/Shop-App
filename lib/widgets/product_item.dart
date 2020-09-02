import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: true);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: product.toggleFavorite,
            ),
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
            },
          ),
          title: FittedBox(
            child: Text(
              product.title,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }
}
