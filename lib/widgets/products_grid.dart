import 'package:flutter/material.dart';
import '../providers/product_providers.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFav;
  ProductsGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final ProductsData = Provider.of<Products>(context);
    final productsList = isFav ? ProductsData.favourites : ProductsData.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: productsList[i],
        // create: (c) => productsList[i],
        child: ProductItem(),
      ),
      itemCount: productsList.length,
    );
  }
}
