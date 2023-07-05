import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/User_ProductItem.dart';
import '../providers/product_providers.dart';
import '../widgets/mainPagedrawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/manageProducts';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndStoreProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: "");
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: DrawerScreen(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: ((ctx, productsData, _) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: productsData.item.isEmpty
                                ? const Center(
                                    child: Text(
                                        "You Dont have any Products, Try Adding some"),
                                  )
                                : ListView.builder(
                                    itemBuilder: ((_, index) => Column(
                                          children: [
                                            UserProductItem(
                                              productsData.item[index].title,
                                              productsData.item[index].imageUrl,
                                              productsData.item[index].id,
                                            ),
                                            const Divider(
                                                thickness: 2,
                                                color: Color.fromARGB(
                                                    255, 232, 132, 212),
                                                indent: 2),
                                          ],
                                        )),
                                    itemCount: productsData.item.length,
                                  ),
                          )),
                    ),
                  ),
      ),
    );
  }
}
