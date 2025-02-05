import 'package:expense_app_tracker/Edit_ItemScreen.dart';
import 'package:expense_app_tracker/Shared/Cubit.dart';
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
            AppCubit.get(context).editwithsameFeatuares =
                AppCubit.get(context).items[index]['id'] - 1;
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
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green[700],
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    '${AppCubit.get(context).items[index]['price']} \$',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  '${AppCubit.get(context).items[index]['category']}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _getCategoryColor(
                        AppCubit.get(context).items[index]['category']),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    '${AppCubit.get(context).items[index]['title']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${AppCubit.get(context).items[index]['date']}',
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
Widget noItems() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey[500],
        ),
        Text(
          "There is no Items",
          style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              fontSize: 40),
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
