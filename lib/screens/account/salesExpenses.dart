import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; 
import 'package:myproject1/db/model/data_model.dart'; 
import 'package:intl/intl.dart'; 

// Define FilterOption enum and SalesExpenses widget
enum FilterOption { daily, weekly, monthly, yearly }

class SalesExpenses extends StatefulWidget {
  const SalesExpenses({Key? key}) : super(key: key);

  @override
  _SalesExpensesState createState() => _SalesExpensesState();
}

class _SalesExpensesState extends State<SalesExpenses> {
  FilterOption _selectedFilter = FilterOption.daily;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Income & Expenses',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 108, 110, 208),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Filter options
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                filterButton(FilterOption.daily, 'Daily'),
                filterButton(FilterOption.weekly, 'Weekly'),
                filterButton(FilterOption.monthly, 'Monthly'),
                filterButton(FilterOption.yearly, 'Yearly'),
              ],
            ),
            const SizedBox(height: 10),
            // FutureBuilder to display data based on selected filter
            FutureBuilder<List<dailyupdatesmodel>>(
              future: getFilteredData(_selectedFilter),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dailyupdatesmodel>? filteredData = snapshot.data;
                  if (filteredData == null || filteredData.isEmpty) {
                    return const Center(
                        child: Text("No data available for the selected filter."));
                  } else {
                    double annualIncome = calculateAnnualIncome(filteredData);
                    double annualExpense = calculateAnnualExpense(filteredData);

                    return Column(
                      children: [
                        _buildBarChart(filteredData),
                        const SizedBox(height: 20),
                        _buildDataList(filteredData),
                        const SizedBox(height: 20),
                        _buildAnnualTotals(annualIncome, annualExpense),
                      ],
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // Function to build the bar chart
  Widget _buildBarChart(List<dailyupdatesmodel> data) {
    List<BarChartGroupData> barGroups = [];

    // Populate income and expense data points
    for (int i = 0; i < data.length; i++) {
      double income = double.tryParse(data[i].income ?? '') ?? 0;
      double expense = double.tryParse(data[i].expense ?? '') ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: income,
              colors: [Colors.blue],
              width: 15,
            ),
            BarChartRodData(
              y: expense,
              colors: [Colors.red],
              width: 15,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 300, // Specify the height of the bar chart
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                if (value.toInt() < data.length) {
                  DateTime date = DateTime.parse(data[value.toInt()].date ?? '');
                  return DateFormat('MM/yyyy').format(date);
                } else {
                  return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                switch (value.toInt()) {
                  case 5000:
                    return '5k';
                  case 10000:
                    return '10k';
                  case 20000:
                    return '20k';
                  case 50000:
                    return '50k';
                  case 100000:
                    return '100k';
                  case 1000000:
                    return '1M';
                  default:
                    return '';
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataList(List<dailyupdatesmodel> data) {
    return Column(
      children: data.map((dailyupdatesmodel entry) {
        return SizedBox(
          width: 400,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                    'Income & Expense',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
                  Text('Date: ${entry.date}'),
                  Text('Category: ${entry.selectedcategory}'),
                  Text('Income: ${entry.income}'),
                  Text('Expenses: ${entry.expense}'),
                  Text('Profit: ${calculateProfit(entry)}'),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget to display annual totals
  Widget _buildAnnualTotals(double annualIncome, double annualExpense) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Annual Totals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Total Income: ${annualIncome.toStringAsFixed(2)}'),
            Text('Total Expenses: ${annualExpense.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

 
  Widget filterButton(FilterOption option, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = option;
        });
      },
      
      child: Text(label),
    );
  }

  // Function to get filtered data based on selected filter
  Future<List<dailyupdatesmodel>> getFilteredData(FilterOption option) async {
    final dUpdates = await Hive.openBox<dailyupdatesmodel>('dailyupdates_db');
    late List<dailyupdatesmodel> filteredData;

    switch (option) {
      case FilterOption.daily:
        filteredData = dUpdates.values.where((element) => element.date == DateTime.now().toString().split(' ')[0]).toList();
        break;
      case FilterOption.weekly:
        filteredData = dUpdates.values.where((element) {
          DateTime elementDate = DateTime.parse(element.date.toString());
          return elementDate.isAfter(DateTime.now().subtract(const Duration(days: 7))) && elementDate.isBefore(DateTime.now());
        }).toList();
        break;
      case FilterOption.monthly:
        filteredData = dUpdates.values.where((element) {
          DateTime elementDate = DateTime.parse(element.date.toString());
          return elementDate.month == DateTime.now().month && elementDate.year == DateTime.now().year;
        }).toList();
        break;
      case FilterOption.yearly:
        filteredData = dUpdates.values.where((element) {
          DateTime elementDate = DateTime.parse(element.date!);
          return elementDate.year == DateTime.now().year;
        }).toList();
        break;
    }

    await dUpdates.close();
    return filteredData;
  }

  // Function to calculate the annual income
  double calculateAnnualIncome(List<dailyupdatesmodel> data) {
    return data.fold(0, (sum, item) => sum + (double.tryParse(item.income ?? '') ?? 0));
  }

  // Function to calculate the annual expense
  double calculateAnnualExpense(List<dailyupdatesmodel> data) {
    return data.fold(0, (sum, item) => sum + (double.tryParse(item.expense ?? '') ?? 0));
  }

  String calculateProfit(dailyupdatesmodel data) {
    double income = double.tryParse(data.income ?? '') ?? 0;
    double expenses = double.tryParse(data.expense ?? '') ?? 0;

    double profit = income - expenses;

    return profit.toString();
  }
}
