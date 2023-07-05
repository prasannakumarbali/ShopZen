import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/user_productscreen.dart';
import '../screens/Orders_Screen.dart';
import '../providers/auth_user.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Buy anything!'),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Go To Store'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('MY Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MyFinalOrders.routeNamed);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage my Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log out'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Logged Out Successfully!!'),
                  elevation: 5,
                  dismissDirection: DismissDirection.down,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
