import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditItemscreen extends StatefulWidget {
  const EditItemscreen({super.key});

  @override
  State<EditItemscreen> createState() => _EditItemscreenState();
}

class _EditItemscreenState extends State<EditItemscreen> {
  late String selectedCategoryLocal;

  @override
  void initState() {
    super.initState();
    var cubit = AppCubit.get(context);
    // Initialize controllers only once
    cubit.itemDateController.text =
        cubit.items[cubit.editwithsameFeatuares]['date'] ?? "";
    cubit.itemNameController.text =
        cubit.items[cubit.editwithsameFeatuares]['title'] ?? "";
    cubit.itemPriceController.text =
        cubit.items[cubit.editwithsameFeatuares]['price']?.toString() ?? "";

    // Set the category from the item
    selectedCategoryLocal =
        cubit.items[cubit.editwithsameFeatuares]['category'] ?? 'Others';
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFF3498DB),
        title: const Text(
          'Edit Expense',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: cubit.FormKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3498DB).withOpacity(0.15),
                            offset: const Offset(0, 4),
                            blurStyle: BlurStyle.normal,
                            blurRadius: 12,
                          )
                        ],
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the item name';
                            }
                            return null;
                          },
                          controller: cubit.itemNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF3498DB), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.shopping_cart,
                                color: Color(0xFF3498DB)),
                            label: const Text('Item Name'),
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the item price';
                            }
                          
                            return null;
                          },
                          controller: cubit.itemPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF3498DB), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.attach_money,
                                color: Color(0xFF3498DB)),
                            label: const Text('Item Price'),
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, innerSetState) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.category,
                                    color: Color(0xFF3498DB)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              value: selectedCategoryLocal,
                              items: cubit.categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(category),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(category),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  innerSetState(() {
                                    selectedCategoryLocal = value;
                                  });
                                }
                              },
                              validator: (value) => value == null
                                  ? 'Please select a category'
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the item date';
                            }
                            return null;
                          },
                          controller: cubit.itemDateController,
                          onTap: () => showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(DateTime.now().year + 10),
                          ).then((value) {
                            if (value != null) {
                              cubit.itemDateController.text =
                                  DateFormat.yMMMMd().format(value);
                            }
                          }),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF3498DB), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: Color(0xFF3498DB)),
                            label: const Text('Item Date'),
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                          keyboardType: TextInputType.none,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                        color: const Color(0xFF3498DB),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3498DB).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: MaterialButton(
                      onPressed: () {
                        if (cubit.FormKey.currentState!.validate()) {
                          cubit
                              .updateDataInDatabase(
                            id: cubit.editedetemId,
                            title: cubit.itemNameController.text,
                            price: int.parse(cubit.itemPriceController.text),
                            date: cubit.itemDateController.text,
                            category: selectedCategoryLocal,
                          )
                              .then((value) {
                            cubit.clearControllers();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                closeIconColor: Colors.white,
                                showCloseIcon: true,
                                backgroundColor: const Color(0xFF3498DB),
                                behavior: SnackBarBehavior.floating,
                                content: const Text(
                                  "Expense updated successfully!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text(
                        'Update Expense',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
