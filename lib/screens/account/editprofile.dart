import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject1/screens/account/account.dart';
import 'package:myproject1/db/functions/db_functions.dart';

import 'package:myproject1/db/model/data_model.dart';

class Editprofile extends StatefulWidget {
  datamodels data;
  Editprofile({super.key, required this.data});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class ImagePickerService {
  final _picker = ImagePicker();

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}

class _EditprofileState extends State<Editprofile> {
  File? image;
  final ImagePickerService imagePicker = ImagePickerService();

  Future<void> _getImage() async {
    final pickedImage = await imagePicker.pickImage();
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  late TextEditingController usernamecontroller;
  late TextEditingController mailcontroller;
  late TextEditingController passwordcontroller;
  String textValue = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    usernamecontroller = TextEditingController(text: widget.data.username);
    mailcontroller = TextEditingController(text: widget.data.email);
    passwordcontroller = TextEditingController(text: widget.data.password);
    if (widget.data.image?.isNotEmpty == true) {
      image = File(widget.data.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
        title:const Text('Edit Profile',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
          )),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                color: const Color.fromARGB(255, 108, 110, 208),
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _getImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            image != null ? FileImage(image!) : null,
                        child: image == null
                            ? const Icon(Icons.add_a_photo, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Add New Photo',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            textValue = value;
                          });
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: usernamecontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the username';
                          }
                          if (value.length <= 3) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
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
                        height: 40,
                      ),
                      InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                     if (_formKey.currentState!.validate()) {
                            buttonclicked();

                            // String enteredtext = usernamecontroller.text;
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Account()));
                          }
                       },
                 child: Container(
                padding: const EdgeInsets.all(12.0),
                   decoration: BoxDecoration(
                    gradient: const LinearGradient( begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                      colors: [
                       const Color.fromARGB(255, 18, 25, 223),
                       Color.fromARGB(255, 109, 3, 127)
                    ]),
                  
                     borderRadius: BorderRadius.circular(8.0),
                     ),
                   child: const Text(
                 'Update Profile',
                    style: TextStyle(color: Colors.white),
               ),
           ),
          ),
              
                     
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> buttonclicked() async {
    final name = usernamecontroller.text.trim();
    final mail = mailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    final id = widget.data.id;
    print(id);
    if (name.isEmpty || mail.isEmpty || password.isEmpty) {
      return;
    }
    final editing = datamodels(
        username: name,
        email: mail,
        password: password,
        image: image?.path ?? '');
    editdetails(id!, editing);
  }
}
