import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/config/routes/app_route.dart';
import 'package:hospital/config/themes/theme_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                "Welcome Back !!", 
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

                    //email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration:  const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Enter the email",
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
                          login(emailController.text.trim(), passwordController.text.trim());
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

                    const SizedBox(height: 24,),


                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoute.signup);
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                            )
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(14)
                          )
                        ),
                        child:  const Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),

                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, AppRoute.admin_home),
                        child: const Text(
                          "Continue as Admin?",
                          style: TextStyle(
                            fontSize: 18,
                            color: colorSecondary,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    )
                  ],

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  void login(String email, String password) async{

    try {
      UserCredential _ = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      route();


    } on FirebaseAuthException catch (_) {

        const snackBar = SnackBar(
            content: Text('invalid credentials. retry'),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }
  
  void route() {
    
    User? user = FirebaseAuth.instance.currentUser;

    var _ = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .get()
                          .then((DocumentSnapshot doc) {

                            if (doc.exists) {
                              
                              Navigator.pushReplacementNamed(context, AppRoute.user_home);

                            } else {
                              const snackBar = SnackBar(
                                content: Text('something went wrong'),
                                duration: Duration(seconds: 3),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });

  }
}