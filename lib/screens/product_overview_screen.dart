import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/mainPagedrawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/product_providers.dart';

enum FavouriteFilter { Favourites, ShowAll }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavourites = false;
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndStoreProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FavouriteFilter selectedValue) {
              setState(() {
                if (selectedValue == FavouriteFilter.Favourites) {
                  _showFavourites = true;
                } else {
                  _showFavourites = false;
                }
              });
            },
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FavouriteFilter.Favourites,
                child: Text("My Favourites"),
              ),
              const PopupMenuItem(
                value: FavouriteFilter.ShowAll,
                child: Text("All"),
              ),
            ],
          ),
          // Using Provider at only specific part of the screen
          Consumer<Cart>(
            builder: (context, cart, child) => Badges(
              value: cart.itemCount.toString(),
              color: Colors.red,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerScreen(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavourites),
    );
  }
}
