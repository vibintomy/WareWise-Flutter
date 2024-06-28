import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class productcontent extends StatefulWidget {
  final dynamic categoryid;
  const productcontent({Key? key, required this.categoryid}) : super(key: key);

  @override
  State<productcontent> createState() => _productcontentState();
}

class _productcontentState extends State<productcontent> {
  final TextEditingController itemnameController1 = TextEditingController();
  final TextEditingController descriptionController1 = TextEditingController();
  final TextEditingController stockController1 = TextEditingController();
  final TextEditingController currentpricecontoller = TextEditingController();
  final TextEditingController sellingpricecontoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  int totalStock = 0; // Added total stock variable
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
        title: const Text('Add Products',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                const Text(
                'Add Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 225, 225),
                    borderRadius: BorderRadius.circular(10),
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
              const SizedBox(height: 20),
              const Text(
                'Add Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: itemnameController1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter the fields';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Item Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: stockController1,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter the fields';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    totalStock = int.tryParse(value) ?? 0;
                  });
                },
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
                controller: currentpricecontoller,
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
                controller: sellingpricecontoller,
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
              Container(
                height: 200,
                child: TextField(
                  controller: descriptionController1,
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
                    
                          buttonClicked();
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                       },
                 child: Container(
                padding: EdgeInsets.all(12.0),
                   decoration: BoxDecoration(
                    gradient: LinearGradient( begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                      colors: [
                       Color.fromARGB(255, 18, 25, 223),
                       const Color.fromARGB(255, 109, 3, 127)
                    ]),
                  
                     borderRadius: BorderRadius.circular(8.0),
                     ),
                   child: Center(
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
    );
  }

  Future<void> buttonClicked() async {
  final itemName1 = itemnameController1.text.trim();
  final stock1 = stockController1.text.trim();
  final currentprice = currentpricecontoller.text.trim();
  final sellingprice = sellingpricecontoller.text.trim();
  final description1 = descriptionController1.text.trim();

  if (itemName1.isEmpty ||
      stock1.isEmpty ||
      description1.isEmpty ||
      sellingprice.isEmpty ||
      currentprice.isEmpty) {
    return;
  }

  final int stock = int.tryParse(stock1) ?? 0;

  final products = productmodel(
    itemname1: itemName1,
    stock1: stock1,
    totalproducts: stock,
    discription1: description1,
    image: _image?.path ?? '',
    categoryid: widget.categoryid,
    sellingprice: sellingprice,
    currentprice: currentprice,
  );

 
  await addproduct(products, widget.categoryid);

  // Fetch all products for the current category and update totalStock
  final List<productmodel> allProducts =
      await getproductList();
  int totalStock = 0;
  allProducts.forEach((product) {
    totalStock += int.tryParse(product.stock1.toString()) ?? 0;
  });

  setState(() {
    this.totalStock = totalStock;
  });

  // Clear the form fields after adding the product
  itemnameController1.clear();
  stockController1.clear();
  currentpricecontoller.clear();
  sellingpricecontoller.clear();
  descriptionController1.clear();
  setState(() {
    _image = null;
  });
}

}
