import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/account/salesExpenses.dart';
import 'package:myproject1/screens/home/inventorysummary.dart';
import 'package:myproject1/screens/home/tabBar.dart';
import 'package:myproject1/screens/home/widget/carousel.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    geteditlist();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color.fromARGB(255, 202, 195, 195),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with User Greeting
                SafeArea(child: _buildHeader()),
                const SizedBox(height: 30),

                // Card Row for Sales Invoice and Income & Expenses
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildCard(
                        title: 'Sales Invoice',
                        gradient: const LinearGradient(
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                        ),
                        icon: Icons.receipt_long,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const tabBarPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildCard(
                        title: 'Income & Expenses',
                        gradient: const LinearGradient(
                          colors: [Colors.purpleAccent, Colors.deepPurple],
                        ),
                        icon: Icons.trending_up,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ImprovedSalesExpenses(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Inventory Summary Card
                Center(
                  child: _buildCard(
                    title: 'Inventory Summary',
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlue],
                    ),
                    icon: Icons.inventory,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventorySummaryChart(
                            getProductList: () async {
                              return await getproductList();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const  SizedBox(height: 20,),
              ProductCarousel(productListNotifier: productListNotifier)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Row(
      children: [
        ValueListenableBuilder<List<datamodels>>(
          valueListenable: editlistnotifier,
          builder:
              (BuildContext ctx, List<datamodels> editList, Widget? child) {
            if (editList.isEmpty) {
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              );
            }
            datamodels data = editList.last;
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (data.image != null && data.image!.isNotEmpty)
                            ? FileImage(File(data.image!))
                            : null,
                    child: (data.image == null || data.image!.isEmpty)
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Hi, ${data.username.toString().toUpperCase()} 👋',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // Enhanced Card Widget
  Widget _buildCard({
    required String title,
    required LinearGradient gradient,
    required IconData icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
