import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class Editproduct extends StatefulWidget {
  final productmodel data;
  const Editproduct({Key? key, required this.data}) : super(key: key);

  @override
  State<Editproduct> createState() => _EditproductState();
}

class _EditproductState extends State<Editproduct> {
  File? _image;
  late TextEditingController itemnameController;
  late TextEditingController stockController;
   late TextEditingController currentpricecontroller ;
  late TextEditingController sellingpricecontroller;
  late TextEditingController discriptioncontroller;
  
 

  void initState() {
    super.initState();
    itemnameController = TextEditingController(text: widget.data.itemname1);
    stockController = TextEditingController(text: widget.data.stock1);
     currentpricecontroller =
        TextEditingController(text: widget.data.currentprice );
    sellingpricecontroller =
        TextEditingController(text: widget.data.sellingprice);
    discriptioncontroller =
        TextEditingController(text: widget.data.discription1);
   

    if (widget.data.image?.isNotEmpty == true) {
      _image = File(widget.data.image!);
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Edit Products',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 108, 110, 208))),
            GestureDetector(
              onTap: _getImage,
              child: Card(
            
                shadowColor: Colors.grey,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 225, 225),
                    borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle
                  ),
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
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: itemnameController,
              decoration: InputDecoration(
                hintText: 'Item Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Available stock',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: currentpricecontroller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the fields';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  hintText: 'Current price',
                  
                  border: OutlineInputBorder(
                    
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: sellingpricecontroller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the fields';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                  hintText: 'selling price',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: TextField(
                controller: discriptioncontroller,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Give Description About the product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
             InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                     
                       setState(() {
                  buttonclicked();
                  Navigator.pop(context);
                });
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
    );
  }

  Future<void> buttonclicked() async {
    final itemname1 = itemnameController.text.trim();
    final stock1 = stockController.text.trim();
    final id = widget.data.id2;
    final currentprice = currentpricecontroller.text.trim();
    final discription = discriptioncontroller.text.trim();
    final sellingprice = sellingpricecontroller.text.trim();

    if (itemname1.isEmpty ||
        stock1.isEmpty ||
        currentprice.isEmpty ||
        discription.isEmpty ||
        sellingprice.isEmpty) {
      return;
    }
    final editing3 = productmodel(
      itemname1: itemname1,
      stock1: stock1,
      image: _image?.path ?? '',
      discription1: discription,
      currentprice: currentprice,
      sellingprice: sellingprice,
    );
    await editdetails4(id!, editing3);
    print('data edited');
  }
}
