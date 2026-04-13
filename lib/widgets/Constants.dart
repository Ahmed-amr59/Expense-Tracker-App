import 'package:expense_app_tracker/view/Edit_ItemScreen.dart';
import 'package:expense_app_tracker/view_model/Cubit.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

Widget itemWidget(context, index) => Slidable(
      key: Key('${AppCubit.get(context).items[index]['id']}'),
      startActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          key: Key('${AppCubit.get(context).items[index]['id']}_Edit'),
          onPressed: (context) {
            AppCubit.get(context).editedetemId =
                AppCubit.get(context).items[index]['id'];
            AppCubit.get(context).editwithsameFeatuares = index;
            Navigator.push(
              context,
              _createSlideTransition(
                page: EditItemscreen(),
              ),
            );
          },
          backgroundColor: const Color(0xFF2ECC71),
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
                    backgroundColor: const Color(0xFFE74C3C),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: Text(
                      "You have deleted an amount",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              );
            });
          },
          backgroundColor: const Color(0xFFE74C3C),
          icon: Icons.delete_forever_outlined,
          foregroundColor: Colors.white,
          label: 'Delete',
        ),
      ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                            AppCubit.get(context).items[index]['category'])
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${AppCubit.get(context).items[index]['price']} \$',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: _getCategoryColor(
                          AppCubit.get(context).items[index]['category']),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        '${AppCubit.get(context).items[index]['title']}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${AppCubit.get(context).items[index]['date']}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(AppCubit.get(context)
                                      .items[index]['category'])
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${AppCubit.get(context).items[index]['category']}',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
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
            color: const Color(0xFF3498DB).withOpacity(0.12),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Color(0xFF3498DB),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "No Expenses Yet",
          style: GoogleFonts.poppins(
            color: const Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Start tracking your expenses by clicking the\nadd button below",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
Color _getCategoryColor(String category) {
  switch (category) {
    case 'Supplies':
      return const Color(0xFFE74C3C);
    case 'Rent':
      return const Color(0xFF27AE60);
    case 'Food':
      return const Color(0xFF3498DB);
    case 'Luxury':
      return const Color(0xFF9B59B6);
    case 'Education':
      return const Color(0xFFF39C12);
    case 'Others':
      return const Color(0xFF1ABC9C);
    default:
      return Colors.grey;
  }
}

// App Theme Colors
class AppColors {
  static const Color primary = Color(0xFF2E86AB);
  static const Color secondary = Color(0xFF27AE60);
  static const Color accent = Color(0xFF3498DB);
  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMedium = Color(0xFF5A6C7D);
  static const Color textLight = Color(0xFF95A5A6);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color warningOrange = Color(0xFFE67E22);
  static const Color dangerRed = Color(0xFFE74C3C);
  static const Color infoBlue = Color(0xFF3498DB);
}

// Custom Page Route with Slide Animation
Route _createSlideTransition({required Widget page}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

// App Text Styles using Google Fonts
class AppTextStyles {
  static TextStyle headingLarge() => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        letterSpacing: -0.5,
      );

  static TextStyle headingMedium() => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
        letterSpacing: 0.3,
      );

  static TextStyle headingSmall() => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      );

  static TextStyle bodyLarge() => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  static TextStyle bodyMedium() => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textMedium,
      );

  static TextStyle bodySmall() => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textLight,
      );

  static TextStyle labelLarge() => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.5,
      );

  static TextStyle labelMedium() => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
