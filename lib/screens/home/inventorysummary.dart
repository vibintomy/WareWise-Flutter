import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myproject1/db/model/data_model.dart';

class InventorySummaryChart extends StatelessWidget {
  final Future<List<productmodel>> Function() getProductList;

  const InventorySummaryChart({Key? key, required this.getProductList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for a modern look
      body: FutureBuilder<List<productmodel>>(
        future: getProductList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            List<productmodel>? products = snapshot.data;
            if (products == null || products.isEmpty) {
              return Center(
                child: Text(
                  'No Inventory Data Available',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              );
            } else {
              return _buildInventorySummary(context, products);
            }
          }
        },
      ),
    );
  }

  Widget _buildInventorySummary(BuildContext context, List<productmodel> products) {
    int totalProducts = products.length;
    num totalStock = 0;
    int stockoutsCount = 0;

    for (var product in products) {
      try {
        num productStock = num.tryParse(product.stock1.toString()) ?? 0;
        totalStock += productStock;
        if (productStock == 0) stockoutsCount++;
      } catch (e) {
        print('Error parsing stock for product: ${product}');
      }
    }

    List<PieChartSectionData> sections = [];
    if (totalStock > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.teal,
          value: totalStock.toDouble(),
          title: 'Available\n$totalStock',
          radius: 120,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    if (stockoutsCount > 0) {
      sections.add(
        PieChartSectionData(
          color: Colors.redAccent,
          value: stockoutsCount.toDouble(),
          title: 'Out of Stock\n$stockoutsCount',
          radius: 120,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 20,),
            // Header
            Center(
              child: const Text(
                'Inventory Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Summary Card with Shadow and Gradient
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Total Products', totalProducts, Colors.white),
                        _buildStat('In Stock', totalStock, Colors.teal[100]!),
                        _buildStat('Out of Stock', stockoutsCount, Colors.red[100]!),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Pie Chart Section
            const Text(
              'Inventory Distribution',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 50,
                  sectionsSpace: 4,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Product Details Section
            const Text(
              'Product Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                bool isOutOfStock = (num.tryParse(product.stock1.toString()) ?? 0) == 0;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isOutOfStock ? Colors.redAccent : Colors.teal,
                      child: Text(
                        product.itemname1?[0] ?? '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      product.itemname1 ?? 'Unknown Product',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      'Stock: ${product.stock1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isOutOfStock ? Colors.redAccent : Colors.teal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, num value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}