import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';

import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/mainfiles/login.dart';

class signup extends StatelessWidget {
  signup({super.key});
  final _formKey = GlobalKey<FormState>();
  final usernamecontroller = TextEditingController();
  final mailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final repasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 167, 212, 248),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Center(
                        child: Text(
                      'Sign Up Now',
                      style: TextStyle(fontSize: 40, color: Colors.blue),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: usernamecontroller,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: mailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: passwordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter the password';
                        }
                        if (value.length <= 3 && value.length >= 15) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: repasswordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please ReEnter the password';
                        }
                        if (value.length <= 3 && value.length >= 15) {
                          return 'Enter a valid password';
                        }
                        if (passwordcontroller.text !=
                            repasswordcontroller.text) {
                          return 'Enter the valid password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'ReConfirm the Password',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                     
                        buttonclicked();
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginpage()));
                        }
                       },
                 child: Container(
                padding: const EdgeInsets.all(12.0),
                   decoration: BoxDecoration(
                    gradient: const LinearGradient( begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                      colors: [
                       Color.fromARGB(255, 18, 25, 223),
                       Color.fromARGB(255, 109, 3, 127)
                    ]),
                  
                     borderRadius: BorderRadius.circular(8.0),
                     ),
                   child: const Text(
                 'signup',
                    style: TextStyle(color: Colors.white),
               ),
           ),
          ),
                  
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonclicked() async {
    final username = usernamecontroller.text.trim();
    final mail = mailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    final repassword = repasswordcontroller.text.trim();

    if (username.isEmpty ||
        mail.isEmpty ||
        password.isEmpty ||
        repassword.isEmpty) {
      return;
    }
    final signup = datamodels(
      username: username,
      email: mail,
      password: password,
    );
    addprofile(signup);
  
  }
}
