import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class DailyUpdates extends StatefulWidget {
  DailyUpdates({Key? key}) : super(key: key);

  @override
  _DailyUpdatesState createState() => _DailyUpdatesState();
}

class _DailyUpdatesState extends State<DailyUpdates> {
  final formKey = GlobalKey<FormState>();
  List<String> selectedItems = [];
  List<itemsmodel> categories = [];
  List<String> selectedProducts = [];
  List<productmodel> products = [];
  TextEditingController incomeController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool showCategories = true;
  bool showProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchProducts();
  }

  void _fetchCategories() async {
    List<itemsmodel>? categoryList = await getItemList();
    if (categoryList != null) {
      setState(() {
        categories = categoryList;
      });
    }
  }

  void _fetchProducts() async {
    List<productmodel>? productList = await getproductList();
    if (productList != null) {
      setState(() {
        products = productList;
      });
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
          'Daily Updates',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  'Sales Of The Day',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showCategories = !showCategories;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(showCategories
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showCategories,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(categories[index].items),
                                value: selectedItems
                                    .contains(categories[index].items),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value!) {
                                      selectedItems
                                          .add(categories[index].items);
                                    } else {
                                      selectedItems
                                          .remove(categories[index].items);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showProducts = !showProducts;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select Products',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(showProducts
                                  ? Icons.expand_less
                                  : Icons.expand_more),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: showProducts,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(products[index].itemname1),
                                value: selectedProducts
                                    .contains(products[index].id2.toString()),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value!) {
                                      selectedProducts
                                          .add(products[index].id2.toString());
                                    } else {
                                      selectedProducts.remove(
                                          products[index].id2.toString());
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        hintText: 'Date ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Income',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: incomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter The Fields';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Income For The Day ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: expenseController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter The Fields';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Expense For The Day ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                 InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                  onTap: () {
                     if (formKey.currentState!.validate()) {
                      buttonclicked();
                      Navigator.pop(context);
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
                 'Save',
                    style: TextStyle(color: Colors.white),
               ),
           ),
          ),
                  
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonclicked() async {
    final date = dateController.text.trim();
    final income = incomeController.text.trim();
    final expense = expenseController.text.trim();
    

    if (date.isEmpty || income.isEmpty || expense.isEmpty) {
      return;
    }

    final selectedCategoriesList = List<String>.from(selectedItems);
    final selectedProductsList = List<String>.from(selectedProducts);

    final dailyupdates = dailyupdatesmodel(
      date: date,
      expense: expense,
      income: income,
      selectedcategory: selectedCategoriesList.toString(),
      selectedproduct: selectedProductsList.toString(),
    );

    // Add the dailyupdates data to the database
    await addDailyupdates(dailyupdates);
   
  }
}
