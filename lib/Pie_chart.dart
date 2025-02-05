import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:expense_app_tracker/Shared/Cubit.dart';
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
      double roundedValue = double.parse(entry.value.toStringAsFixed(1)); // Round to one decimal place
      return PieData(
        value: roundedValue, // Use the rounded value
        color: _getCategoryColor(entry.key),
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          setState(() {
            Navigator.pop(context);
          });
        }, icon:Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        backgroundColor: Colors.blue,
        title: Text(
          'Statistics',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pie Chart
          Expanded(
            flex: 2,
            child: Center(
              child: EasyPieChart(
                borderWidth: 50,
                gap: 1,
                size: 300,
                borderEdge: StrokeCap.butt,
                centerStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                centerText: "Percentage",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                children: pieData,
              ),
            ),
          ),

          // Legend
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildLegend(categoryPercentages),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the legend
  Widget _buildLegend(Map<String, double> categoryPercentages) {
    return ListView(
      children: categoryPercentages.entries
          .where((entry) => entry.value > 0) // Filter out categories with value == 0
          .map((entry) {
        return ListTile(
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _getCategoryColor(entry.key),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            entry.key,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            "${entry.value.toStringAsFixed(1)}%", // Display percentage
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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