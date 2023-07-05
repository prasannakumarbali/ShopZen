import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class Cart_Item extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final String productId;
  final int quantity;
  Cart_Item(this.id, this.productId, this.price, this.title, this.quantity);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        color: const Color.fromARGB(255, 245, 130, 42),
        child: Icon(Icons.delete),
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
             elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  title: const Text('Are you Sure ?'),
                  content: const Text(
                      'Do you really want to remove the Product from the Cart ?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('NO'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('YES'),
                    ),
                  ],
                ),);
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: FittedBox(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text("\u{20B9} $price")),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total : \u{20B9} ${price * quantity}'),
            trailing: Text('x ' + quantity.toString()),
          ),
        ),
      ),
    );
  }
}
