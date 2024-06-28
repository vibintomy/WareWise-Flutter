import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/home/showdialog.dart';

class Invoice1 extends StatefulWidget {
  final productmodel? data2;
  const Invoice1({Key? key, required this.data2});

  @override
  State<Invoice1> createState() => _Invoice1State();
}

class _Invoice1State extends State<Invoice1> {
  TextEditingController customernamecontroller = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late List<itemsmodel> itemsList;
  late List<productmodel> productsList;
  List<Map<String, dynamic>> invoiceList = [];
  itemsmodel? selectedCategory;
  productmodel? selectedProduct;
  final formKey = GlobalKey<FormState>();
  double discount = 0.0; // Track discount
  double totalPrice = 0.0; // Track total price

  @override
  void initState() {
    super.initState();
    itemsList = [];
    productsList = [];
    _fetchData();
  }

  @override
  void dispose() {
    customernamecontroller.dispose();
    discountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final items = await getItemList();
      final products = await getproductList();
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        itemsList = items;
        productsList = products;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _showInvoiceDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ShowDialogBox(
        itemsList: itemsList,
        productsList: productsList,
        selectedCategory: selectedCategory,
        selectedProduct: selectedProduct,
        price: 0.0,
        quantity: 0,
      ),
    );

    if (result != null) {
      setState(() {
        invoiceList.add(result);
        _updateTotalPrice(); // Update total price whenever a new item is added
      });
    }
  }

  void _updateTotalPrice() {
    totalPrice = 0.0;
    for (var invoice in invoiceList) {
      double itemPrice = invoice['price'];
      double discountedPrice = calculateDiscountedPrice(itemPrice, discount);
      totalPrice += discountedPrice;
    }
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {}); // Update the state to reflect the new total price
  }

  double calculateDiscountedPrice(double originalPrice, double discount) {
    if (discount <= 0) {
      return originalPrice;
    } else {
      double discountedAmount = originalPrice * (discount / 100);
      return originalPrice - discountedAmount;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        dateController.text = pickedDate.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bill Invoice',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: customernamecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the customer name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Customer Name',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Date of Purchase',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select Date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                DataTable(
                  columnSpacing: 24,
                  horizontalMargin: 15,
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Category',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text('Product',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Quantity',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Price',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: invoiceList.map((invoice) {
                    double originalPrice = invoice['price'];
                    double discountedPrice =
                        calculateDiscountedPrice(originalPrice, discount);
                    return DataRow(cells: [
                      DataCell(Text(invoice['category'])),
                      DataCell(Text(invoice['product'])),
                      DataCell(Text(invoice['quantity'].toString())),
                      DataCell(Text(discountedPrice.toStringAsFixed(2))),
                    ]);
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Discount%',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: discountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the discount ';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Discount (%)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      discount = double.tryParse(value) ?? 0.0;
                      _updateTotalPrice();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Total Price: ${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: InkWell(
                    hoverColor: const Color.fromARGB(255, 78, 2, 92),
                    focusColor: Colors.blue,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        buttonclicked();
                        Navigator.pop(context);
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
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInvoiceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> buttonclicked() async {
    final date = dateController.text.trim();
    final customername = customernamecontroller.text.trim();
    final discountText = discountController.text.trim();

    final discount = double.tryParse(discountText) ?? 0.0;

    List<Map<String, dynamic>> invoiceData = invoiceList.map((invoice) {
      return {
        'category': invoice['category'],
        'product': invoice['product'],
        'quantity': invoice['quantity'],
        'price': invoice['price'],
        'discounted_price':
            calculateDiscountedPrice(invoice['price'], discount),
      };
    }).toList();

    if (date.isEmpty || customername.isEmpty || invoiceData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all required fields.'),
      ));
      return;
    }

    final invoiceupdates = InvoiceModel(
      date: date,
      customername: customername,
      discount: discount,
      invoice: invoiceData,
      totalamount: totalPrice,
    );

    try {
      await addinvoice(invoiceupdates);
      await _decrementProductStock();
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invoice saved successfully.'),
      ));
    } catch (error) {
      print('Error saving invoice: $error');
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to save invoice. Please try again.'),
      ));
    }
  }

  Future<void> _decrementProductStock() async {
    for (var invoice in invoiceList) {
      final productName = invoice['product'];
      final quantity = invoice['quantity'];

      final product = productsList.firstWhere(
        (product) => product.itemname1 == productName,
      );
      if (product == null) {
        print('Product not found: $productName');
        continue;
      }

      final updatedStock = (int.tryParse(product.stock1.toString()) ?? 0) - quantity;
      productmodel updatedData = productmodel(
        image: product.image,
        itemname1: product.itemname1,
        stock1: updatedStock.toString(),
        currentprice: product.currentprice,
        sellingprice: product.sellingprice,
      );

      try {
        await editdetails4(product.id2!, updatedData);
        print('Stock updated for product: ${product.itemname1}');
      } catch (error) {
        print('Error updating stock for product: ${product.itemname1} - $error');
      }
    }

    // Fetch updated products list to refresh UI
    await _fetchData();
  }
}
