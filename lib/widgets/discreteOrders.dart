import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart';

class OrderItemsFinal extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemsFinal(this.orderItem);

  @override
  State<OrderItemsFinal> createState() => _OrderItemsFinalState();
}

class _OrderItemsFinalState extends State<OrderItemsFinal> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 8,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\u{20B9}${widget.orderItem.amount}'),
            subtitle:
                Text(widget.orderItem.dateTime.toString().substring(0, 10)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.all(10),
              height: min(widget.orderItem.products.length * 20.0 + 10, 180.0),
              child: ListView.builder(
                itemBuilder: ((context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.orderItem.products[index].title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'x ${widget.orderItem.products[index].quantity}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                itemCount: widget.orderItem.products.length,
              ),
            )
        ],
      ),
    );
  }
}
