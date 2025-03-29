import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myproject1/db/functions/db_functions.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:myproject1/screens/category/editproduct.dart';
import 'package:myproject1/screens/category/productcontent.dart';

class Products extends StatefulWidget {
  final itemsmodel data;

  Products({Key? key, required this.data}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Future<void> _refreshSubcategories() async => setState(() {});

  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool showPriceRangeChips = false;
  final priceRangeOptions = ["15k to 25k", "25k to 50k", "50k to 150k", "All Products"];
  String selectedPriceRange = "All Products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        title: const Text(
          'Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => setState(() => showPriceRangeChips = !showPriceRangeChips),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: showPriceRangeChips ? 60 : 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: priceRangeOptions.map((priceRange) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilterChip(
                          label: Text(priceRange, style: const TextStyle(color: Colors.white)),
                          selected: selectedPriceRange == priceRange,
                          onSelected: (selected) => setState(() => selectedPriceRange = selected ? priceRange : "All Products"),
                          backgroundColor: Colors.deepPurple.shade300,
                          selectedColor: Colors.deepPurple,
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                  hintText: 'Search Products',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (query) => setState(() => _searchQuery = query),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: FutureBuilder<List<productmodel>>(
                  future: getproductList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                    } else {
                      List<productmodel>? products = snapshot.data;
                      final filterData = products?.where((sub) => sub.categoryid == widget.data.categoryid).toList();
                      final filteredProducts = _searchQuery.isEmpty
                          ? filterData
                          : filterData?.where((product) => product.itemname1.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                      if (filteredProducts == null || filteredProducts.isEmpty) {
                        return const Center(child: Text('No Data Available', style: TextStyle(fontSize: 18, color: Colors.grey)));
                      }

                      List<productmodel> priceRangeFilteredProducts = filteredProducts!;
                      if (selectedPriceRange != "All Products") {
                        priceRangeFilteredProducts = priceRangeFilteredProducts.where((product) {
                          double price = double.parse(product.sellingprice ?? '0');
                          switch (selectedPriceRange) {
                            case "15k to 25k": return price >= 15000 && price <= 25000;
                            case "25k to 50k": return price >= 25000 && price <= 50000;
                            case "50k to 150k": return price >= 50000 && price <= 150000;
                            default: return true;
                          }
                        }).toList();
                      }

                      return ListView.builder(
                        itemCount: priceRangeFilteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = priceRangeFilteredProducts[index];
                          return Slidable(
                            key: ValueKey(product.id2),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Editproduct(data: product)),
                                    );
                                    if (result == null) setState(() {});
                                  },
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (_) => _showDeleteDialog(context, product),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: product.image != null
                                      ? Image.file(File(product.image!), width: 120, height: 200, fit: BoxFit.contain)
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade200,
                                          child: const Center(child: Text('No Image', style: TextStyle(color: Colors.grey))),
                                        ),
                                ),
                                title: Text(
                                  product.itemname1,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text('Price: ₹${product.sellingprice ?? ''}', style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                onTap: () => _showProductDetails(context, product),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => productcontent(categoryid: widget.data.categoryid))).then((_) => _refreshSubcategories()),
        child:  Icon(Icons.add, color: Colors.white),
        elevation: 10,
      ),
    );
  }

  void _showProductDetails(BuildContext context, productmodel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Container(width: 50, height: 5, color: Colors.grey.shade300, margin: const EdgeInsets.only(bottom: 10)),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: product.image != null
                    ? Image.file(File(product.image!), height: 200, fit: BoxFit.contain)
                    : Container(height: 200, color: Colors.grey.shade200, child: const Center(child: Text('No Image'))),
              ),
              const SizedBox(height: 20),
              Text(product.itemname1, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stock:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(product.stock1 ?? '', style: const TextStyle(fontSize: 18, color: Colors.green)),
                ],
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Current Price:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('₹${product.currentprice ?? ''}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Selling Price:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('₹${product.sellingprice ?? ''}', style: const TextStyle(fontSize: 16, color: Colors.red)),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Description:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(product.discription1 ?? '', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, productmodel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Delete Product', style: TextStyle(color: Colors.deepPurple)),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (product.id2 != null) {
                deleteproduct(product.id2!);
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}