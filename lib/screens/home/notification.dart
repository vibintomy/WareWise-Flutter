import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController returnProductController = TextEditingController();
  TextEditingController damagedProductController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                FutureBuilder<List<productmodel>>(
                  future: getproductList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<productmodel>? products = snapshot.data;
                      if (products == null || products.isEmpty) {
                        return const Center(
                          child: Text('No data is available'),
                        );
                      } else {
                        num totalStock = 0;
                        int stockoutsCount = 0;

                        // Calculate total stock and stockouts
                        products.forEach((product) {
                          totalStock += num.parse(product.stock1.toString());
                          if (int.parse(product.stock1.toString()) == 0) {
                            stockoutsCount++;
                          }
                        });

                        return Center(
                          child: Column(
                            children: [
                              Text(
                                'Total Products: ${products.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Available Stock: $totalStock',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Out of Stock: $stockoutsCount',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'Returned products count',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: returnProductController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the count';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Count',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Damaged Products',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: damagedProductController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the count';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Count',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                hoverColor: const Color.fromARGB(255, 78, 2, 92),
                                focusColor: Colors.blue,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    buttonClicked(
                                      totalStock,
                                      products.length,
                                      int.parse(returnProductController.text),
                                      int.parse(damagedProductController.text),
                                      stockoutsCount,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color.fromARGB(255, 18, 25, 223),
                                        Color.fromARGB(255, 109, 3, 127),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonClicked(
    num totalStock,
    int totalProducts,
    int returnedProducts,
    int damagedProducts,
    int stockouts,
  ) async {
    final returnProducts = productreturnmodel(
      returnproducts: returnedProducts.toString(),
      damagedproducts: damagedProducts.toString(),
      totalstock: totalStock.toString(),
      totalproducts: totalProducts.toString(),
      totaldamagedproducts: damagedProducts.toString(),
      totalreturnproducts: returnedProducts.toString(),
      stockouts: stockouts,
    );

    await addproductreturns(returnProducts);
  }
}
