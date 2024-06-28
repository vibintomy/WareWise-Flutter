import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class Editcategory extends StatefulWidget {
  final itemsmodel data;

  Editcategory({Key? key, required this.data}) : super(key: key);

  @override
  State<Editcategory> createState() => _EditcategoryState();
}

class _EditcategoryState extends State<Editcategory> {
  File? image;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController itemcontroller1;
  late TextEditingController itemcountcontroller2;

  @override
  void initState() {
    super.initState();
    itemcontroller1 = TextEditingController(text: widget.data.items);
    itemcountcontroller2 = TextEditingController(text: widget.data.itemcount);

    if (widget.data.image?.isNotEmpty == true) {
      image = File(widget.data.image!);
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromARGB(255, 108, 110, 208),
        title: const Center(child: Text('Update Category',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onDoubleTap: _getImage,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(255, 226, 226, 226),
                      child: image != null && image!.path.isNotEmpty
                          ? Image.file(
                              image!,
                              fit: BoxFit.cover,
                            )
                          : (widget.data.image != null &&
                                  widget.data.image!.isNotEmpty)
                              ? Image.file(
                                  File(widget.data.image!),
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 50.0,
                                  color: Colors.black,
                                ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Change Photo",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Edit Category ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    controller: itemcontroller1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the Field';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Item',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: itemcountcontroller2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the Field';
                      }

                      if (!RegExp(r'^[0-9]$').hasMatch(value)) {
                        return 'Please enter a valid fields';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Item Count',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    // style: ElevatedButton.styleFrom(primary:Color.fromARGB(
                    //                                     255, 108, 110, 208)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        buttonclicked();
                        Navigator.pop(context, true); 
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonclicked() async {
  final item = itemcontroller1.text.trim();
  final itemcount = itemcountcontroller2.text.trim();
  final id = widget.data.id1;
  print(id);
  if (item.isEmpty || itemcount.isEmpty) {
    return;
  }
  final editing1 = itemsmodel(
    items: item,
    itemcount: itemcount,
    image: image?.path ?? '',
  );
  await editdetails2(id!, editing1); // Wait for the editing process to complete
  print('data edited');
}
}
