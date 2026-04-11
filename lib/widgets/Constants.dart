import 'package:expense_app_tracker/view/Edit_ItemScreen.dart';
import 'package:expense_app_tracker/view_model/Cubit.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget itemWidget(context, index) => Slidable(
      key: Key('${AppCubit.get(context).items[index]['id']}'),
      startActionPane: ActionPane(motion: StretchMotion(), children: [
        SlidableAction(
          key: Key('${AppCubit.get(context).items[index]['id']}_Edit'),
          onPressed: (context) {
            AppCubit.get(context).editedetemId =
                AppCubit.get(context).items[index]['id'];
            AppCubit.get(context).editwithsameFeatuares = index;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditItemscreen()));
          },
          backgroundColor: Colors.green,
          icon: Icons.edit,
          foregroundColor: Colors.white,
          label: 'Edit',
        ),
        SlidableAction(
          key: Key('${AppCubit.get(context).items[index]['id']}_Delete'),
          onPressed: (context) {
            AppCubit.get(context)
                .deleteDataFromDatabase(
                    itemId: AppCubit.get(context).items[index]['id'])
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    closeIconColor: Colors.white,
                    showCloseIcon: true,
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      "You have deleted an amount",
                      style: TextStyle(color: Colors.white),
                    )),
              );
            });
          },
          backgroundColor: Colors.red,
          icon: Icons.delete_forever_outlined,
          foregroundColor: Colors.white,
          label: 'Delete',
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                            AppCubit.get(context).items[index]['category'])
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${AppCubit.get(context).items[index]['price']} \$',
                    style: TextStyle(
                        color: _getCategoryColor(
                            AppCubit.get(context).items[index]['category']),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        '${AppCubit.get(context).items[index]['title']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${AppCubit.get(context).items[index]['date']}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(AppCubit.get(context)
                                      .items[index]['category'])
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${AppCubit.get(context).items[index]['category']}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _getCategoryColor(AppCubit.get(context)
                                    .items[index]['category']),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
Widget noItems() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF3498DB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Color(0xFF3498DB),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "No Expenses Yet",
          style: TextStyle(
              color: Color(0xFF2C3E50),
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        Text(
          "Start tracking your expenses by clicking the\nadd button below",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
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
