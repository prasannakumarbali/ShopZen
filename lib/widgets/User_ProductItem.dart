import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';

import '../providers/product_providers.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String iD;
  UserProductItem(this.title, this.imageUrl, this.iD);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: iD);
            },
            icon: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 38, 227, 44),
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<Products>(context, listen: false)
                  .deleteProduct(iD)
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product Deleted'),
                  ),
                );
              });
            },
            icon: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 235, 41, 41),
            ),
          )
        ],
      ),
    );
  }
}
