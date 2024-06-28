import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class Sales extends StatefulWidget {
  final itemsmodel data;
  final productmodel? data2;

  Sales({Key? key, required this.data, required this.data2}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  TextEditingController datecontroller = TextEditingController();
  TextEditingController customernamecontroller = TextEditingController();
  late TextEditingController categorycontroller = TextEditingController();
  late TextEditingController productcontroller = TextEditingController();
  late TextEditingController pricecontroller = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController discountcontroller = TextEditingController();

  int quantity = 0;
  int steppervalue = 0;
  double price = 0.0; // Initialize price here
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    categorycontroller = TextEditingController(text: widget.data.items);
    productcontroller = TextEditingController(text: widget.data2!.itemname1);
    pricecontroller = TextEditingController(text: widget.data2!.sellingprice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            'INVOICE#',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                'Customer Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: customernamecontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter the customer name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Customer Name',
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              TextField(
                controller: datecontroller,
                decoration: const InputDecoration(
                  labelText: 'DATE',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              const Divider(),
              const Row(
                children: [
                  Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 170),
                  Text(
                    'Product',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: TextField(
                      controller: categorycontroller,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 75),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: TextField(
                      controller: productcontroller,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      readOnly: true,
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Selling Price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  const SizedBox(
                    width: 110,
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: TextField(
                      controller: pricecontroller,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      readOnly: true,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                        errorText: _validateQuantity(quantityController.text),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          // Recalculate price when quantity changes

                          quantity = int.tryParse(value) ?? 0;
                          price = quantity *
                              parseSellingPrice(widget.data2?.sellingprice);
                          calculatePrice();
                        });
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          steppervalue = (steppervalue - 1).clamp(0, 100);
                          quantityController.text = steppervalue.toString();
                          quantity = steppervalue;
                          price = quantity *
                              parseSellingPrice(widget.data2?.sellingprice);
                          calculatePrice();
                        });
                      },
                      icon: const Icon(Icons.remove)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          steppervalue = (steppervalue + 1).clamp(0, 100);
                          quantityController.text = steppervalue.toString();
                          quantity = steppervalue;
                          price = quantity *
                              parseSellingPrice(widget.data2?.sellingprice);
                          calculatePrice();
                        });
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Discount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Give Discount for the product';
                  }
                  return null;
                },
                controller: discountcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Discount',
                ),
                onChanged: (value) {
                  setState(() {
                    calculatePrice();
                  });
                },
              ),
              const Divider(),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Price: \u20B9${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (formKey.currentState!.validate()) {
                          buttonclicked();
                          Navigator.pop(context);
                        }
                      });
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('SAVE')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        datecontroller.text = picked.toString().split(" ")[0];
      });
    }
  }

  double parseSellingPrice(dynamic value) {
    if (value == null) {
      return 0.0;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print("Error parsing sellingprice: $e");
      }
    }
    return 0.0;
  }

  String? _validateQuantity(String? value) {
    if (value != null && value.isNotEmpty) {
      int quantity = int.tryParse(value) ?? 0;
      int availableStock = int.tryParse(widget.data2?.stock1 ?? '0') ?? 0;
      if (quantity > availableStock) {
        return 'Quantity exceeds available stock';
      }
    }

    return null;
  }

  void calculatePrice() {
    int quantity = int.tryParse(quantityController.text) ?? 0;
    double discount = double.tryParse(discountcontroller.text) ?? 0.0;
    double sellingPrice = parseSellingPrice(widget.data2?.sellingprice);
    price = (quantity * sellingPrice - discount).clamp(0, double.infinity);
  }

  Future<void> buttonclicked() async {
    final date = datecontroller.text.trim();
    final customername = customernamecontroller.text.trim();
    final category = categorycontroller.text.trim();
    final product = productcontroller.text.trim();
    final quantity = quantityController.text.trim();
    final discount = discountcontroller.text.trim();
    final salesprice = pricecontroller.text.trim();
    final price1 = price;
    final id = widget.data2?.id2;

    if (date.isEmpty ||
        customername.isEmpty ||
        category.isEmpty ||
        product.isEmpty ||
        quantity.isEmpty ||
        discount.isEmpty ||
        salesprice.isEmpty) {
      return;
    }

    final sales = salesmodel(
        customername: customername,
        date: date,
        category: category,
        product: product,
        quantity: quantity,
        salesprice: salesprice,
        sellingprice: price1,
        discount: discount,
        productid: widget.data2!.productid);
    await addsales(sales, widget.data2!.productid ?? 0);
    print('data passed');

    int updatedstock = (int.tryParse(widget.data2!.stock1 ?? '0') ?? 0) -
        (int.tryParse(quantity) ?? 0);
    productmodel updatedData = productmodel(
        image: widget.data2!.image,
        itemname1: widget.data2!.itemname1,
        stock1: updatedstock.toString(),
        currentprice: widget.data2!.currentprice,
        sellingprice: widget.data2!.sellingprice);

    await editdetails4(id!, updatedData);
   
  }
}
