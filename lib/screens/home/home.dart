import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/account/salesExpenses.dart';
import 'package:myproject1/screens/home/inventorysummary.dart';
import 'package:myproject1/screens/home/tabBar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 202, 195, 195),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Set the main axis size to min
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        ValueListenableBuilder<List<datamodels>>(
                          valueListenable: editlistnotifier,
                          builder: (BuildContext ctx, List<datamodels> editList,
                              Widget? child) {
                            if (editList.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            datamodels data = editList.last;
                            return Row(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        const Color.fromARGB(255, 138, 26, 26),
                                    backgroundImage: (data.image != null &&
                                            data.image!.isNotEmpty)
                                        ? FileImage(File(data.image!))
                                        : null,
                                    child: (data.image == null ||
                                            data.image!.isEmpty)
                                        ? const Icon(
                                            Icons.person,
                                            size: 50.0,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Hi, ${data.username.toString().toUpperCase()}👋',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            );
                          },
                        ),
                        const Text(
                          '',
                          style: TextStyle(
                            color: Color.fromARGB(255, 87, 109, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        const SizedBox(width: 190),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildCard(
                            title: 'SALES INVOICE',
                            color: const Color.fromARGB(255, 251, 105, 20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const tabBarPage(),
                                ),
                              );
                            },
                            image: Image.asset('assets/procurement.png')),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildCard(
                            title: 'Income & Expenses',
                            color: const Color.fromARGB(255, 253, 79, 236),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SalesExpenses(),
                                ),
                              );
                            },
                            image: Image.asset(
                                'assets/increase.png') // Icon for Income & Expenses
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      _buildCard(
                          title: 'Inventory summary',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Inventorysummary()));
                          },
                          image: Image.asset('assets/supplier.png'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Color color,
    required Function() onTap,
    required Widget image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: image,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
