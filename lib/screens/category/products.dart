import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/category/editproduct.dart';
import 'package:myproject1/screens/category/productcontent.dart';

class Products extends StatefulWidget {
  final itemsmodel data;

  Products({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Future<void> _refreshSubcategories() async {
    setState(() {});
  }

  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool showpricerangechips = false;
  final priceRangeOptions = [
    "15k to 25k",
    "25k to 50k",
    "50k to 150k",
    "All Products"
  ];
  String SelectedPriceRange = "All Products";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
        title: const Text(
          'Products',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      showpricerangechips = !showpricerangechips;
                    });
                  },
                  icon: const Icon(Icons.filter_list)),
            ),
            Visibility(
              visible: showpricerangechips,
              child: Wrap(
                spacing: 8.0,
                children: priceRangeOptions.map((String priceRange) {
                  return ChoiceChip(
                    label: Text(priceRange),
                    selected: SelectedPriceRange == priceRange,
                    onSelected: (bool selected) {
                      setState(() {
                        SelectedPriceRange = selected ? priceRange : null!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                hintText: 'Search Products',
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FutureBuilder<List<productmodel>>(
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
                        final filterData = products
                            ?.where((sub) =>
                                sub.categoryid == widget.data.categoryid)
                            .toList();
                        final filteredProducts = _searchQuery.isEmpty
                            ? filterData
                            : filterData
                                ?.where((product) => product.itemname1
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()))
                                .toList();
                        if (filteredProducts == null ||
                            filteredProducts.isEmpty) {
                          return const Center(
                            child: Text(
                              'No data available ',
                              style: TextStyle(fontSize: 18),
                            ),
                          );
                        } else {
                          List<productmodel>? priceRangeFilteredProducts =
                              filteredProducts;
                          if (SelectedPriceRange != "All Products") {
                            switch (SelectedPriceRange) {
                              case "15k to 25k":
                                priceRangeFilteredProducts =
                                    priceRangeFilteredProducts
                                        .where((products) =>
                                            double.parse(
                                                    products.sellingprice!) >=
                                                15000 &&
                                            double.parse(
                                                    products.sellingprice!) <=
                                                25000)
                                        .toList();
                                break;

                              case "25k to 50k":
                                priceRangeFilteredProducts =
                                    priceRangeFilteredProducts
                                        .where((products) =>
                                            double.parse(
                                                    products.sellingprice!) >=
                                                25000 &&
                                            double.parse(
                                                    products.sellingprice!) <=
                                                50000)
                                        .toList();
                                break;

                              case "50k to 150k":
                                priceRangeFilteredProducts =
                                    priceRangeFilteredProducts
                                        .where((products) =>
                                            double.parse(
                                                    products.sellingprice!) >=
                                                50000 &&
                                            double.parse(
                                                    products.sellingprice!) <=
                                                150000)
                                        .toList();
                                break;
                              default:
                                break;
                            }
                            if (priceRangeFilteredProducts == null ||
                                priceRangeFilteredProducts.isEmpty) {
                              return const Center(
                                child: Text('No Data Available'),
                              );
                            }
                          }
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: priceRangeFilteredProducts.length,
                              itemBuilder: (context, index) {
                                final product =
                                    priceRangeFilteredProducts![index];
                                return Column(
                                  children: [
                                    Slidable(
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 249, 234, 234),
                                        shadowColor: Colors.grey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (BuildContext
                                                              context) {
                                                            return SizedBox(
                                                              height: 800,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    SizedBox(
                                                                  width: 400,
                                                                  height: 400,
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        width:
                                                                            200,
                                                                      ),
                                                                      CloseButton(
                                                                        color: Colors
                                                                            .black,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            200,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            image: product.image != null
                                                                                ? DecorationImage(
                                                                                    image: FileImage(
                                                                                      File(product.image ?? ''),
                                                                                    ),
                                                                                    fit: BoxFit.cover,
                                                                                  )
                                                                                : null // Handle null image
                                                                            ),
                                                                        child: product.image ==
                                                                                null
                                                                            ? const Center(
                                                                                child: Text(
                                                                                  'No Image Available',
                                                                                  style: TextStyle(fontSize: 16),
                                                                                ),
                                                                              )
                                                                            : null,
                                                                      ),
                                                                      Text(
                                                                        product
                                                                            .itemname1,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                25,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      const Text(
                                                                        'Available Stock',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .blueAccent,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      Text(
                                                                        product
                                                                            .stock1!,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .green,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const Divider(),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Align(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Text(
                                                                              'current price  :₹',
                                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                50,
                                                                          ),
                                                                          Text(
                                                                            product.currentprice ??
                                                                                '',
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Text(
                                                                            'Selling Price  :₹',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                50,
                                                                          ),
                                                                          Text(
                                                                            product.sellingprice ??
                                                                                '',
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const Divider(),
                                                                      const Align(
                                                                          alignment: Alignment
                                                                              .topLeft,
                                                                          child:
                                                                              Text(
                                                                            'Product Details :',
                                                                            style:
                                                                                TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                                                          )),
                                                                      Align(
                                                                          alignment: Alignment
                                                                              .topLeft,
                                                                          child:
                                                                              Text(
                                                                            product.discription1 ??
                                                                                '',
                                                                            style:
                                                                                const TextStyle(fontSize: 15),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: product.image !=
                                                                null
                                                            ? DecorationImage(
                                                                image:
                                                                    FileImage(
                                                                  File(product
                                                                          .image ??
                                                                      ''),
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : null, // Handle null image
                                                      ),
                                                      child:
                                                          product.image == null
                                                              ? const Center(
                                                                  child: Text(
                                                                    'No Image Available',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )
                                                              : null,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          product.itemname1,
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        const Text(
                                                          'Price',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '₹${product.sellingprice ?? ''}',
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      229,
                                                                      42,
                                                                      42),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  final result = await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Editproduct(data: product)));
                                                                  if (result ==
                                                                      null) {
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .edit)),
                                                            IconButton(
                                                              iconSize: 24,
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            const Text(
                                                                          'Delete product',
                                                                          style:
                                                                              TextStyle(color: Color.fromARGB(255, 6, 61, 106)),
                                                                        ),
                                                                        content:
                                                                            const Text('Are you sure You want to delete'),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  if (product.id2 != null) {
                                                                                    deleteproduct(product.id2!);
                                                                                    print('Deletion is successful');
                                                                                  } else {
                                                                                    print('Item id is null');
                                                                                  }
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text(
                                                                                'Yes',
                                                                                style: TextStyle(color: Colors.red),
                                                                              )),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('No'))
                                                                        ],
                                                                      );
                                                                    });
                                                              },
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => productcontent(
                categoryid: widget.data.categoryid,
              ),
            ),
          ).then((value) {
            _refreshSubcategories();
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
