import 'package:flutter/material.dart';
import 'package:mi_inversion_app/screens/login/components/MyTextField.dart';

import 'dart:convert';
import '../../../main.dart';


import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

   bool _isLoading = false;

    signIn(String email, pass) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        'email': email,
        'password': pass
      };
      var jsonResponse = null;

      var response = await http.post(Uri.parse("http://192.168.0.14:8000/signin"), body: data);
      if(response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if(jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
        
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage()), (Route<dynamic> route) => false);
        }
      }
      else {
        setState(() {
          _isLoading = false;
        });
        const snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content:Text('Correo o contraseña incorrecta'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          print(response.body);
      }
    }

    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo2.jpg',
                  height: 120,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 70),
                  child: Text(
                    "Bienvenido",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MyTextField(
                  hint: "Email",
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  isPassword: false,
                ),
                MyTextField(
                  hint: "Password",
                  controller: passwordController,
                  inputType: TextInputType.text,
                  isPassword: true,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
                      setState(() {
                        _isLoading = true;
                      });
                    signIn(emailController.text, passwordController.text);
                    },
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }


}