import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:flutter/material.dart';

class Pie_chart extends StatefulWidget {
  const Pie_chart({super.key});

  @override
  State<Pie_chart> createState() => _PiechartState();
}

class _PiechartState extends State<Pie_chart> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var categoryPercentages = cubit.calculateCategoryPercentages();

    // Convert the percentages to PieData objects
    List<PieData> pieData = categoryPercentages.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
      double roundedValue = double.parse(
          entry.value.toStringAsFixed(1)); // Round to one decimal place
      return PieData(
        value: roundedValue, // Use the rounded value
        color: _getCategoryColor(entry.key),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFF3498DB),
        title: const Text(
          'Expense Statistics',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pie Chart
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3498DB).withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: pieData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pie_chart_outline,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No data available',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : EasyPieChart(
                        borderWidth: 50,
                        gap: 1,
                        size: 280,
                        borderEdge: StrokeCap.butt,
                        centerStyle: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        centerText: "Categories",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                        children: pieData,
                      ),
              ),
            ),
          ),

          // Legend
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3498DB).withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildLegend(categoryPercentages),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper method to build the legend
  Widget _buildLegend(Map<String, double> categoryPercentages) {
    return ListView(
      children: categoryPercentages.entries
          .where((entry) =>
              entry.value > 0) // Filter out categories with value == 0
          .map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _getCategoryColor(entry.key).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: _getCategoryColor(entry.key).withOpacity(0.3),
                  width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50)),
                  ),
                ),
                Text(
                  "${entry.value.toStringAsFixed(1)}%", // Display percentage
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3498DB)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Helper method to assign colors to categories
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Supplies':
        return Colors.red;
      case 'Rent':
        return Colors.green;
      case 'Food':
        return Colors.blue;
      case 'Luxury':
        return Colors.deepPurpleAccent;
      case 'Education':
        return Colors.amber;
      case 'Others':
        return Colors.cyanAccent;
      default:
        return Colors.grey;
    }
  }
}
