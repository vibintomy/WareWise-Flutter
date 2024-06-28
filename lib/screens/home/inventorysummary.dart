import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class productreturnmodel {
  String? totalstock;
  String? damagedproducts;
  String? returnproducts;
  int? stockouts;

  productreturnmodel(
      {this.totalstock,
      this.damagedproducts,
      this.returnproducts,
      this.stockouts});
}

Future<List<productreturnmodel>> getproductreturns() async {
  // Replace with your actual data fetching logic
  return [
    productreturnmodel(
        totalstock: '100',
        damagedproducts: '20',
        returnproducts: '30',
        stockouts: 10),
    productreturnmodel(
        totalstock: '200',
        damagedproducts: '40',
        returnproducts: '50',
        stockouts: 20),
    productreturnmodel(
        totalstock: '300',
        damagedproducts: '60',
        returnproducts: '70',
        stockouts: 30),
  ];
}

class Inventorysummary extends StatelessWidget {
  const Inventorysummary({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 108, 110, 208),
            title: const Text(
              'Inventory Summary',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
          ),
        ),
        body: FutureBuilder<List<productreturnmodel>>(
          future: getproductreturns(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<productreturnmodel>? products = snapshot.data;
              if (products == null || products.isEmpty) {
                return const Center(
                  child: Text('No data is available'),
                );
              } else {
                // Summing up the values
                double totalStock = products
                    .map((p) => double.parse(p.totalstock ?? '0'))
                    .reduce((a, b) => a + b);
                double damagedProducts = products
                    .map((p) => double.parse(p.damagedproducts ?? '0'))
                    .reduce((a, b) => a + b);
                double returnProducts = products
                    .map((p) => double.parse(p.returnproducts ?? '0'))
                    .reduce((a, b) => a + b);
                double stockouts = products
                    .map((p) => (p.stockouts ?? 0).toDouble())
                    .reduce((a, b) => a + b);

                List<PieChartSectionData> sections = [];

                if (totalStock > 0) {
                  sections.add(PieChartSectionData(
                    value: totalStock,
                    color: Colors.blue,
                    radius: 70,
                    badgeWidget: _badgeWidget(
                        totalStock,
                        totalStock /
                            (totalStock +
                                damagedProducts +
                                returnProducts +
                                stockouts)),
                  ));
                }
                if (damagedProducts > 0) {
                  sections.add(PieChartSectionData(
                    value: damagedProducts,
                    color: Colors.red,
                    radius: 70,
                    badgeWidget: _badgeWidget(
                        damagedProducts,
                        damagedProducts /
                            (totalStock +
                                damagedProducts +
                                returnProducts +
                                stockouts)),
                  ));
                }
                if (returnProducts > 0) {
                  sections.add(PieChartSectionData(
                    value: returnProducts,
                    color: Colors.green,
                    radius: 70,
                    badgeWidget: _badgeWidget(
                        returnProducts,
                        returnProducts /
                            (totalStock +
                                damagedProducts +
                                returnProducts +
                                stockouts)),
                  ));
                }
                if (stockouts > 0) {
                  sections.add(PieChartSectionData(
                    value: stockouts,
                    color: Colors.orange,
                    radius: 70,
                    badgeWidget: _badgeWidget(
                        stockouts,
                        stockouts /
                            (totalStock +
                                damagedProducts +
                                returnProducts +
                                stockouts)),
                  ));
                }

                return Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Inventory Data',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.blue,
                              ),
                              const Text(
                                '  Total Stock',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.red,
                              ),
                              const Text(
                                '  Damaged Products',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.green,
                              ),
                              const Text(
                                '  Return Products',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: Colors.orange,
                              ),
                              const Text(
                                '  Stockouts',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      hoverColor: const Color.fromARGB(255, 78, 2, 92),
                      focusColor: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
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
                        child: const Text(
                          'Ok, I Understand',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _badgeWidget(double value, double percentage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Text(
        '${(percentage * 100).toStringAsFixed(2)}%',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
