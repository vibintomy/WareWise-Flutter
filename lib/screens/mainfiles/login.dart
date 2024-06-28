import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/mainfiles/bottom_navigationbar.dart';
import 'package:myproject1/main.dart';
import 'package:myproject1/screens/mainfiles/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginpage extends StatelessWidget {
  loginpage({super.key});
  final formKey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    geteditlist();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.white,
                  Colors.blue,
                ])),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      'Login Now',
                      style: TextStyle(color: Colors.blue, fontSize: 40),
                    ),
                    const SizedBox(
                      height: 50,
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
                          return 'Enter the valid password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'password',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                     InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                      checkLogin();
                       if (formKey.currentState!.validate()) {
                          String enteredEmail = mailcontroller.text;
                          String enteredPassword = passwordcontroller.text;

                          List<datamodels> editlist = editlistnotifier.value;
                          if (editlist.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No data available. Cannot login.'),
                              ),
                            );
                            return;
                          }

                          datamodels data = editlist.last;

                          if (enteredEmail == data.email &&
                              enteredPassword == data.password) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const bottomNavigation(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Incorrect email or password'),
                              ),
                            );
                          }
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
                 'Login',
                    style: TextStyle(color: Colors.white),
               ),
           ),
          ),
              
                   
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Dont have an account ?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                      checkLogin();
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => signup(),
                          ),
                        );
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

  void checkLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool(SAVE_KEY_NAME, true);
  }
}
