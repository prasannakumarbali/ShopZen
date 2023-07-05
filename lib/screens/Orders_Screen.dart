import 'package:flutter/material.dart';
import 'package:shopping_app/widgets/mainPagedrawer.dart';
import 'package:shopping_app/widgets/discreteOrders.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class MyFinalOrders extends StatefulWidget {
  static const routeNamed = '/orders';

  @override
  State<MyFinalOrders> createState() => _MyFinalOrdersState();
}

class _MyFinalOrdersState extends State<MyFinalOrders> {
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false).fetchAndSet().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Myorders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY ORDERS'),
      ),
      drawer: DrawerScreen(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: ((context, index) =>
                  OrderItemsFinal(Myorders.orders[index])),
              itemCount: Myorders.orders.length,
            ),
    );
  }
}
