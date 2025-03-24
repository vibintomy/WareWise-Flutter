import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject1/screens/account/account.dart';

import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class Addingpage extends StatefulWidget {
  const Addingpage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddingpageState createState() => _AddingpageState();
}

class _AddingpageState extends State<Addingpage> {
  final additems = TextEditingController();
  final additemscount = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        throw Exception('No Image Selected');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _getImage,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(255, 174, 215, 251),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                          child: Text(
                        'Item adding',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: additems,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the Field';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Item name',
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        hoverColor: const Color.fromARGB(255, 78, 2, 92),
                        focusColor: Colors.blue,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            buttonclicked();

                            setState(() {});

                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Account()));
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 18, 25, 223),
                                  Color.fromARGB(255, 109, 3, 127)
                                ]),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> buttonclicked() async {
    final items = additems.text.trim();
    final itemcount = additemscount.text.trim();
    if (items.isEmpty || itemcount.isNotEmpty) {
      return;
    }
    final itemvalues = itemsmodel(
        items: items, itemcount: itemcount, image: _image?.path ?? '');
    addContent(itemvalues);
  }
}
