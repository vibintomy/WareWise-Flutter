import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/home/showdialog.dart';

class ImprovedInvoice extends StatefulWidget {
  final productmodel? data2;
  const ImprovedInvoice({Key? key, required this.data2});

  @override
  State<ImprovedInvoice> createState() => _ImprovedInvoiceState();
}

class _ImprovedInvoiceState extends State<ImprovedInvoice> {
  TextEditingController customernamecontroller = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late List<itemsmodel> itemsList;
  late List<productmodel> productsList;
  List<Map<String, dynamic>> invoiceList = [];
  final formKey = GlobalKey<FormState>();
  double discount = 0.0;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    itemsList = [];
    productsList = [];
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final items = await getItemList();
      final products = await getproductList();
      if (!mounted) return;
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
        price: 0.0,
        quantity: 0,
      ),
    );

    if (result != null) {
      setState(() {
        invoiceList.add(result);
        _updateTotalPrice();
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
    if (!mounted) return;
    setState(() {});
  }

  double calculateDiscountedPrice(double originalPrice, double discount) {
    if (discount <= 0) return originalPrice;
    double discountedAmount = originalPrice * (discount / 100);
    return originalPrice - discountedAmount;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      if (!mounted) return;
      setState(() {
        dateController.text = pickedDate.toString().split(" ")[0];
      });
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice saved successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print('Error saving invoice: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save invoice. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Create Invoice',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade400,
                Colors.deepPurple.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Name Input
                      _buildSectionTitle('Customer Details'),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        controller: customernamecontroller,
                        labelText: 'Customer Name',
                        hintText: 'Enter Customer Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the customer name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Date Picker
                      _buildSectionTitle('Purchase Date'),
                      const SizedBox(height: 10),
                      _buildDatePickerField(context),
                      const SizedBox(height: 15),

                      // Invoice Items Table
                      _buildSectionTitle('Invoice Items'),
                      const SizedBox(height: 10),
                      _buildInvoiceItemsTable(),
                      const SizedBox(height: 15),

                      // Discount Input
                      _buildSectionTitle('Discount'),
                      const SizedBox(height: 10),
                      _buildTextFormField(
                        controller: discountController,
                        labelText: 'Discount Percentage',
                        hintText: 'Enter Discount (%)',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            discount = double.tryParse(value) ?? 0.0;
                            _updateTotalPrice();
                          });
                        },
                      ),
                      const SizedBox(height: 15),

                      // Total Price
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20, 
                            vertical: 10
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Total Price: \₹${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async{
                            if (formKey.currentState!.validate()) {
                              buttonclicked();
                              Navigator.pop(context);
                              final products = await getproductList();
              if (products.isNotEmpty) {
                await purchasedProduct(products[0].id2!);
              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40, 
                              vertical: 12
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Save Invoice',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showInvoiceDialog,
        icon: const Icon(Icons.add,color: Colors.white,),
        label: const Text('Add Item',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple.shade700,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.deepPurple.shade400, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: dateController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
            labelText: 'Select Date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceItemsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.deepPurple.shade50
          ),
          columns: const [
            DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: invoiceList.map((invoice) {
            double originalPrice = invoice['price'];
            double discountedPrice = calculateDiscountedPrice(originalPrice, discount);
            return DataRow(cells: [
              DataCell(Text(invoice['category'])),
              DataCell(Text(invoice['product'])),
              DataCell(Text(invoice['quantity'].toString())),
              DataCell(Text('\₹${discountedPrice.toStringAsFixed(2)}')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // Existing methods like buttonclicked() and _decrementProductStock() remain the same
}