import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddItemscreen extends StatefulWidget {
  const AddItemscreen({super.key});

  @override
  State<AddItemscreen> createState() => _AddItemscreenState();
}

class _AddItemscreenState extends State<AddItemscreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
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
        backgroundColor: const Color(0xFF27AE60),
        title: const Text(
          'Add New Expense',
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
                          color: const Color(0xFF27AE60).withOpacity(.15),
                          offset: const Offset(0, 4),
                          blurStyle: BlurStyle.normal,
                          blurRadius: 12,
                        )
                      ],
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
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
                                  color: Color(0xFF27AE60), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.shopping_cart,
                                color: Color(0xFF27AE60)),
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
                                  color: Color(0xFF27AE60), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.attach_money,
                                color: Color(0xFF27AE60)),
                            label: const Text('Item Price'),
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.category,
                                color: Color(0xFF27AE60)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xFF27AE60), width: 2),
                            ),
                            label: const Text('Select Category'),
                            labelStyle: const TextStyle(color: Colors.grey),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                          ),
                          value: cubit.selectedCategory,
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
                            setState(() {
                              cubit.selectedCategory = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
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
                                  color: Color(0xFF27AE60), width: 2),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: Color(0xFF27AE60)),
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
                        color: const Color(0xFF27AE60),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF27AE60).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: MaterialButton(
                      onPressed: () {
                        if (cubit.FormKey.currentState!.validate()) {
                          cubit
                              .insertToDatabase(
                            title: cubit.itemNameController.text,
                            price: int.parse(cubit.itemPriceController.text),
                            date: cubit.itemDateController.text,
                            category: cubit.selectedCategory!,
                          )
                              .then((value) {
                            cubit.clearControllers();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                closeIconColor: Colors.white,
                                showCloseIcon: true,
                                backgroundColor: const Color(0xFF27AE60),
                                behavior: SnackBarBehavior.floating,
                                content: const Text(
                                  "Expense added successfully!",
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
                        'Add Expense',
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
