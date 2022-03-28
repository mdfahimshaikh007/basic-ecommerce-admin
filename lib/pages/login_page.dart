import 'package:basic_ecommerce/auth/auth_service.dart';
import 'package:basic_ecommerce/pages/dashboard_page.dart';
import 'package:basic_ecommerce/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscuredText = true;
  String _errMsg = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              shrinkWrap: true,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email Address'
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return emptyFieldErrorMsg;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: _obscuredText,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscuredText ? Icons.visibility_off : Icons.visibility),
                        onPressed: (){
                          setState(() {
                            _obscuredText= !_obscuredText;
                          });
                        },
                      ),
                      hintText: 'Enter Password'
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return emptyFieldErrorMsg;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: _loginAdmin,
                ),
                SizedBox(height: 20),
                Text(_errMsg)
              ],
            ),
          )
      ));
  }

  void _loginAdmin() async{
    if(_formKey.currentState!.validate()){
      try{
        final uid = await AuthService.loginAdmin(_emailController.text, _passwordController.text);

        if(uid != null){
          Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      }
    } on FirebaseAuthException catch (error){
        setState(() {
          _errMsg = error.message!;
        });
      }
      }
  }
}
