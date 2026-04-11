import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expense_app_tracker/view_model/States.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;
  bool isLoading =false;
  var FormKey = GlobalKey<FormState>();
  List<Map> items = [];
  final List<String> categories = [
    'Supplies',
    'Rent',
    'Food',
    'Luxury',
    'Education',
    'Others'
  ];

  double calculateTotalSum() {
    double total = 0;
    for (var item in items) {
      total += double.parse(item['price'].toString());
    }
    return total;
  }

  Map<String, double> calculateCategoryPercentages() {
    Map<String, double> categorySums = {};
    double totalSum = calculateTotalSum();

    // Initialize all categories with a sum of 0
    for (var category in categories) {
      categorySums[category] = 0.0;
    }

    // Iterate through the items and sum up the prices for each category
    for (var item in items) {
      String category = item['category'];
      double price = double.parse(item['price'].toString());
      categorySums[category] = (categorySums[category] ?? 0) + price;
    }

    // Calculate the percentage for each category
    Map<String, double> categoryPercentages = {};
    categorySums.forEach((category, sum) {
      categoryPercentages[category] = (sum / totalSum) * 100;
    });

    return categoryPercentages;
  }

  String? selectedCategory;
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDateController = TextEditingController();
  // TextEditingController itemCategoryController = TextEditingController();

  int editedetemId = 0;
  int editwithsameFeatuares=0;
  void createDatabase() async {
    database = await openDatabase(
      "expense_app",
      version: 1,
      onCreate: (Database database, int version) async {
        await database
            .execute(
                'CREATE TABLE Items (id INTEGER PRIMARY KEY, title TEXT, price INTEGER, date TEXT, category TEXT)')
            .then((value) {
          print('Database Created');
        }).catchError((error) {
          print('Error when creating database ${error.toString()}');
        });
      },
      onOpen: (database) async {
        print('Database opened');
        getDataFromDatabase(database);
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required int price,
    required String date,
    required String category,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO Items (title, price, date, category) VALUES ("$title", $price, "$date", "$category")')
          .then((value) {
        print('Data inserted');
        emit(InsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting data ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) async {
    isLoading = true;
    emit(GetDataFromDatabaseState());
    await database.rawQuery('SELECT * FROM Items').then((value) {
      items = [];
      items = value;
      print(value);
      isLoading = false;
      emit(GetDataFromDatabaseState());
    }).catchError((error) {
      isLoading = false;
      print('Error when getting data ${error.toString()}');
      emit(GetDataFromDatabaseState());
    });
  }

  Future deleteDataFromDatabase({required int itemId}) async {
    await database
        .rawDelete('DELETE FROM Items WHERE id = ?', [itemId]).then((value) {
      print('Data deleted');
      emit(DeleteDataFromDatabaseState());
      getDataFromDatabase(database);
    }).catchError((error) {
      print('Error when deleting data ${error.toString()}');
    });
  }

  Future updateDataInDatabase(
    {
    required String title,
    required int price,
    required String date,
    required String category,
    required int id,
    }
  ) async {
    await database.rawUpdate(
        'UPDATE Items SET title = ?, price =?, date =?, category=? WHERE id = ?',
        [title,price,date,category,id]).then((value) {
      print('Data updated');
      emit(UpdateDataFromDatabaseState());
      getDataFromDatabase(database);
    }).catchError((error) {
      print('Error when updating data ${error.toString()}');
    });
  }

  void clearControllers() {
    itemNameController.clear();
    itemPriceController.clear();
    itemDateController.clear();
    selectedCategory = null;
  }

String totalPrice() {
  if (items.isEmpty) {
    return '0'; 
  }
  int total = 0;
  for (var item in items) {
    total += int.parse(item['price'].toString()); 
  }
  final formattedTotal = NumberFormat('#,###').format(total);
  return formattedTotal;
}
}
