import 'package:basic_ecommerce/auth/auth_service.dart';
import 'package:basic_ecommerce/pages/dashboard_page.dart';
import 'package:basic_ecommerce/pages/login_page.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = 'launcher_page';

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      if(AuthService.currentUser==null){
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }else{
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
