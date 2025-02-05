import 'package:expense_app_tracker/Add_ItemScreen.dart';
import 'package:expense_app_tracker/Constants.dart';
import 'package:expense_app_tracker/Pie_chart.dart';
import 'package:expense_app_tracker/Shared/Cubit.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text('Home Screen',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddItemscreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Total Price: ',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Expanded(
                          child: Text(
                            '${AppCubit.get(context).totalPrice()} \$',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Pie_chart()));
               }, icon: Icon(Icons.bar_chart,color: Colors.blue,)),
              ],
            ),
            Expanded(
              child:cubit.isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.blue))
                  : cubit.items.isEmpty
                  ? Center(child: noItems()): ListView.separated(
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
                itemBuilder: (context, index) => itemWidget(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








