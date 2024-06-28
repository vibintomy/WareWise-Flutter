import 'dart:io';
import 'package:flutter/material.dart';

import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/category/editcategory.dart';
import 'package:myproject1/screens/category/products.dart';


class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

int secondselectedindex = 0;

class _CategoriesState extends State<Categories> {
  Future<void> deletItem(int id) async {}

  final searchcontroller = TextEditingController();
  String searchquery = '';

  @override
  Widget build(BuildContext context) {
    setState(() {});

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
                crossAxisAlignment:
                    CrossAxisAlignment.start, 
                children: [
                  const Text(
                    'categories',
                    style: TextStyle(
                      color: Color.fromARGB(255, 87, 109, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: searchcontroller,
                    decoration: InputDecoration(
                        hintText: 'Search Category',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        prefixIcon: const Icon(Icons.search)),
                    onChanged: (query) {
                      setState(() {
                        searchquery = query;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<itemsmodel>>(
                      future: getItemList(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<itemsmodel>? itemsList = snapshot.data;
                          final filterData = itemsList
                              ?.where((sub) => sub.id1 == sub.id1)
                              .toList();
                          final itemList = searchquery.isEmpty
                              ? filterData
                              : filterData
                                  ?.where((itemslist) => itemslist.items
                                      .toLowerCase()
                                      .contains(searchquery.toLowerCase()))
                                  .toList();
                          if (itemList == null || itemList.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          } else {
                            return Column(
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            mainAxisExtent: 270),
                                    itemCount: itemList.length,
                                    itemBuilder: (context, index) {
                                      final data = itemList[index];
                                      return Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                          Products(data: data)),
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: data.image != null
                                                        ? DecorationImage(
                                                            image: FileImage(
                                                                File(data
                                                                    .image!)),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                           const         Row(
                                                      children: [
                                                        Text(
                                                          'Item Name ',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            data.items,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: IconButton(
                                                            iconSize: 16,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      Editcategory(
                                                                          data:
                                                                              data),
                                                                ),
                                                              ).then((value) {
                                                                if (value !=
                                                                        null &&
                                                                    value) {
                                                                  setState(
                                                                      () {});
                                                                }
                                                              });
                                                            },
                                                            icon:const Icon(
                                                                Icons.edit),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          iconSize: 16,
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                      'Delete Category',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              6,
                                                                              61,
                                                                              106)),
                                                                    ),
                                                                    content:const Text(
                                                                        'Are you sure You want to delete'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              if (data.id1 != null) {
                                                                                deleteCategory(data.id1!);
                                                                                print ('Deletion is successful');
                                                                              } else {
                                                                                print('Item id is null');
                                                                              }
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Yes',
                                                                            style:
                                                                                TextStyle(color: Colors.red),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('No'))
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                        const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                      },
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
}
