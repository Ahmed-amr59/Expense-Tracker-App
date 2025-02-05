import 'package:expense_app_tracker/Shared/Cubit.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          setState(() {
            Navigator.pop(context);
          });
        }, icon:Icon(Icons.arrow_back_ios_new,color: Colors.white,)),
        backgroundColor: Colors.orange[600],
        title: Text(
          'Add Item Screen',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: cubit.FormKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                        color: Colors.orange.withOpacity(.8),
                        offset: Offset(0, 3),
                        blurStyle: BlurStyle.normal,
                        blurRadius: 10,
                      )],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange[100],
                      border:Border(
                          bottom: BorderSide(color: Colors.grey),
                      )
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
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.shopping_cart),
                            label: Text(
                              'Item Name',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the item price';
                            }
                            if(int.tryParse(value)==null){
                              return "Please enter number";
                            }
                            return null;
                          },
                          controller: cubit.itemPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.attach_money),
                            label: Text(
                              'Item Price',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                        // TextFormField(
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please enter the item category';
                        //     }
                        //     return null;
                        //   },
                        //   controller: cubit.itemCategoryController,
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //     prefixIcon: Icon(Icons.category),
                        //     label: Text(
                        //       'Item Category',
                        //       style: TextStyle(color: Colors.grey[500]),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.category),
                              border: InputBorder.none,
                              label: Text('Select Category',style:TextStyle(color: Colors.grey[500]),),
                            ),
                            value: cubit.selectedCategory,
                            items: cubit.categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
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
                        ),
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
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 10),
                          ).then((value) => cubit.itemDateController.text =
                              DateFormat.yMMMMd().format(value!)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.calendar_today),
                            label: Text(
                              'Item Date',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          keyboardType: TextInputType.none,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[600],
                        borderRadius: BorderRadius.circular(10)),
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
                            cubit.itemNameController.clear();
                            cubit.itemPriceController.clear();
                            cubit.itemDateController.clear();
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        'Add Item',
                        style: TextStyle(color: Colors.white),
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
}
