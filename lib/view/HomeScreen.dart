import 'package:expense_app_tracker/view/Add_ItemScreen.dart';
import 'package:expense_app_tracker/widgets/Constants.dart';
import 'package:expense_app_tracker/widgets/Pie_chart.dart';
import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2C3E50),
        title: const Text('Expense Tracker',
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddItemscreen()));
        },
        label: const Text('Add Item',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF27AE60),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF27AE60).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.attach_money,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Total Spending',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white70),
                              ),
                              Expanded(
                                child: Text(
                                  '${AppCubit.get(context).totalPrice()} \$',
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFF3498DB), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3498DB).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Pie_chart()));
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: const Icon(Icons.bar_chart,
                          color: Color(0xFF3498DB), size: 32),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cubit.isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.blue))
                  : cubit.items.isEmpty
                      ? Center(child: noItems())
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          // reverse: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) => Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          itemCount: cubit.items.length,
                          itemBuilder: (context, index) =>
                              itemWidget(context, index),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
