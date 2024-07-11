
import 'package:flutter/material.dart';
import 'package:hospital/config/themes/theme_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {


  bool _isObscure = true;
  bool showProgress = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController usernameController = TextEditingController();
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
                "Welcome Aboard !!", 
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 30,),

              const Text(
                "New user? Please register", 
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

                    // username: 

                    TextFormField(
                      controller: usernameController,
                      decoration:  const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Enter the username",
                        border: OutlineInputBorder()
                      ),
                    ),

                    const SizedBox(height: 12,),

                    //email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,

                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return 'Enter email';
                        }

                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                      decoration:  const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Enter the email",
                        border: OutlineInputBorder()
                      ),
                    ),

                    const SizedBox(height: 12,),

                    // password
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },

                      decoration:   InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Enter the Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: _isObscure ? 
                                  const Icon(Icons.visibility) : 
                                  const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        )
                      ),
                    ),


                    const SizedBox(height: 22,),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          setState(() {
                            showProgress = true;
                          });
                          signup(
                            usernameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim()
                          
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24,),

                  ],

                ),
              )
            ],
          ),
        ),
      ),
    );

  }


  void signup(String username, String email, String password) async{
    try {
    if (_formkey.currentState!.validate()) {
      await _auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) {
        postDetailsToFirestore(email, username);
        showSuccessSnackbar(context);
        Navigator.pop(context);
      } )
      .catchError((e) {
        showErrorSnackbar(context, e);
      });
    }
  } catch (e) {
    // Handle errors
    print("Error: $e");
  }
  }

  void showSuccessSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Registration Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(BuildContext context, Exception exception) {
    final snackBar = SnackBar(
      content: Text('Registration Failed: ${exception.toString()}'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  postDetailsToFirestore(String email, String username) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var currentUser = _auth.currentUser;
      if (currentUser != null) {
        CollectionReference ref = firebaseFirestore.collection('users');
        await ref.doc(currentUser.uid).set({
          'email': email,
          'username': username,
        });
      } else {
        throw Exception("Current user is null");
      }
    } catch (e) {
      await _auth.currentUser?.delete();
    }
  }
  
}