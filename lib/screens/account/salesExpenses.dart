

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myproject1/db/model/data_model.dart';
import 'package:intl/intl.dart';

enum FilterOption { daily, weekly, monthly, yearly }

class ImprovedSalesExpenses extends StatefulWidget {
  const ImprovedSalesExpenses({Key? key}) : super(key: key);

  @override
  _ImprovedSalesExpensesState createState() => _ImprovedSalesExpensesState();
}

class _ImprovedSalesExpensesState extends State<ImprovedSalesExpenses> {
  FilterOption _selectedFilter = FilterOption.monthly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          'Financial Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade400,
                Colors.deepPurple.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Filter Options
              _buildFilterOptions(),
              const SizedBox(height: 20),

              // Main Content with FutureBuilder
              FutureBuilder<List<dailyupdatesmodel>>(
                future: getFilteredData(_selectedFilter),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error.toString());
                  } else {
                    List<dailyupdatesmodel>? filteredData = snapshot.data;
                    if (filteredData == null || filteredData.isEmpty) {
                      return _buildNoDataWidget();
                    } else {
                      double annualIncome = calculateAnnualIncome(filteredData);
                      double annualExpense = calculateAnnualExpense(filteredData);

                      return Column(
                        children: [
                          _buildFinancialOverviewCard(annualIncome, annualExpense),
                          const SizedBox(height: 20),
                          _buildImprovedBarChart(filteredData),
                          const SizedBox(height: 20),
                          _buildDetailedTransactionsList(filteredData),
                        ],
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterChip(FilterOption.daily, 'Daily'),
          const SizedBox(width: 8),
          _buildFilterChip(FilterOption.weekly, 'Weekly'),
          const SizedBox(width: 8),
          _buildFilterChip(FilterOption.monthly, 'Monthly'),
          const SizedBox(width: 8),
          _buildFilterChip(FilterOption.yearly, 'Yearly'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(FilterOption option, String label) {
    bool isSelected = _selectedFilter == option;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.deepPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = option;
        });
      },
      selectedColor: Colors.deepPurple,
      backgroundColor: Colors.deepPurple.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildFinancialOverviewCard(double income, double expense) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFinancialStat('Total Income', income, Colors.green),
                _buildFinancialStat('Total Expenses', expense, Colors.red),
                _buildFinancialStat('Net Profit', income - expense, 
                    (income - expense) >= 0 ? Colors.blue : Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialStat(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildImprovedBarChart(List<dailyupdatesmodel> data) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income vs Expenses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: _createBarGroups(data),
                  titlesData: FlTitlesData(
                    bottomTitles: _createBottomTitles(data),
                    leftTitles: _createLeftTitles(),
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.deepPurple.shade100,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.y.toStringAsFixed(2),
                          TextStyle(
                            color: rod.colors[0],
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(List<dailyupdatesmodel> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      dailyupdatesmodel item = entry.value;

      double income = double.tryParse(item.income ?? '') ?? 0;
      double expense = double.tryParse(item.expense ?? '') ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            y: income,
            colors: [Colors.green.shade400],
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            y: expense,
            colors: [Colors.red.shade400],
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  SideTitles _createBottomTitles(List<dailyupdatesmodel> data) {
    return SideTitles(
      showTitles: true,
      getTitles: (value) {
        if (value.toInt() < data.length) {
          DateTime date = DateTime.parse(data[value.toInt()].date ?? '');
          return DateFormat('MM/dd').format(date);
        }
        return '';
      },
      margin: 10,
      rotateAngle: -45,
    
    );
  }

  SideTitles _createLeftTitles() {
    return SideTitles(
      showTitles: true,
      interval: 5000,
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
          default:
            return '';
        }
      },
      margin: 10,
   
    );
  }

  Widget _buildDetailedTransactionsList(List<dailyupdatesmodel> data) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
              itemBuilder: (context, index) {
                var entry = data[index];
                return ListTile(
                  title: Text(
                    entry.selectedcategory ?? 'Unknown Category',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    entry.date ?? 'No Date',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+\$${entry.income ?? '0'}',
                        style: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '-\$${entry.expense ?? '0'}',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade300,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                error,
                style: TextStyle(color: Colors.red.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Card(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.data_usage,
                color: Colors.grey.shade400,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'No Data Available',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Try selecting a different time period',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Existing helper methods remain the same as in the previous implementation
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

  double calculateAnnualIncome(List<dailyupdatesmodel> data) {
   return data.fold(0, (sum, item) => sum + (double.tryParse(item.income ?? '') ?? 0));
  }

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