import 'package:basic_ecommerce/auth/auth_service.dart';
import 'package:basic_ecommerce/pages/login_page.dart';
import 'package:basic_ecommerce/pages/new_product_page.dart';
import 'package:basic_ecommerce/pages/product_list_page.dart';
import 'package:basic_ecommerce/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = 'dashboard_page';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.getAllCategories();
    _productProvider.getAllProducts();
    _productProvider.getAllPurchases();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(onPressed: (){
            AuthService.logout().then((_) {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            });
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: [
          ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          child: Text('ADD PRODUCT'),
          ),
          ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          child: Text('VIEW PRODUCT'),
          ),
          ElevatedButton(
          onPressed: (){},
          child: Text('VIEW CATEGORY'),
          ),
          ElevatedButton(
          onPressed: (){},
          child: Text('VIEW ORDERS'),
          ),
          ElevatedButton(
          onPressed: (){},
          child: Text('VIEW REPORTS'),
          ),
          ElevatedButton(
          onPressed: (){},
          child: Text('MANAGE USERS'),
          ),
        ],
      ),
    );
  }
}
