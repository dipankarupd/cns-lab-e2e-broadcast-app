import 'package:flutter/material.dart';
import 'package:hospital/config/routes/app_route.dart';
import 'package:hospital/config/themes/theme_constants.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 75, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Admin !!", 
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),

              ),


              const SizedBox(height: 30,),

              const Text(
                "Sign in to continue", 
                style:  TextStyle(
                  color: Color(0xff544e64),
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 50,),

              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //username
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: usernameController,
                      decoration:  const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Enter the username",
                        border: OutlineInputBorder()
                      ),
                    ),

                    const SizedBox(height: 12,),

                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration:   InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Enter the Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }, 
                          icon: _isObscure ?
                                const Icon(Icons.visibility):
                                const Icon(Icons.visibility_off)
                        )
                      ),
                    ),

                    const SizedBox(height: 22,),

                    const Text("Forgot Password?", style: TextStyle(color: colorSecondary , fontSize: 16, fontWeight: FontWeight.bold),),

                    const SizedBox(height: 22,),

                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          login(usernameController.text.trim(), passwordController.text.trim());
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ],

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  void login(String username, String password) {

    if (username == 'admin' && password == 'admin') {
      // Navigate
      Navigator.pushReplacementNamed(context, AppRoute.admin_home);
    } else {
      const snackBar = SnackBar(
          content: Text('Invalid login credentials. Try again'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}