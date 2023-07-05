import 'package:flutter/material.dart';
import 'package:shopping_app/providers/auth_user.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import '../screens/cart_screen.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import 'package:shopping_app/screens/user_productscreen.dart';
import './screens/product_overview_screen.dart';
import './providers/product_providers.dart';
import 'package:provider/provider.dart';
import './screens/Orders_Screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products("", "", []),
            update: (context, auth, previous) => Products(auth.Token.toString(),
                auth.userId, previous == null ? [] : previous.item),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders("", "", []),
            update: (context, auth, previous) => Orders(auth.Token.toString(),
                auth.userId, previous == null ? [] : previous.orders),//old orders upload
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,// erase that debug banner on emulator
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.pink,
                hintColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.namedRoute: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              MyFinalOrders.routeNamed: (context) => MyFinalOrders(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        )); 
  }
}
