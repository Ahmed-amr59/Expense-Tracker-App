import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:expense_app_tracker/widgets/Constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pie_chart extends StatefulWidget {
  const Pie_chart({super.key});

  @override
  State<Pie_chart> createState() => _PiechartState();
}

class _PiechartState extends State<Pie_chart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    var categoryPercentages = cubit.calculateCategoryPercentages();

    // Convert the percentages to PieData objects
    List<PieData> pieData = categoryPercentages.entries
        .where((entry) => entry.value > 0)
        .map((entry) {
      double roundedValue = double.parse(entry.value.toStringAsFixed(1));
      return PieData(
        value: roundedValue,
        color: _getCategoryColor(entry.key),
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        backgroundColor: AppColors.accent,
        title: Text(
          'Expense Analytics',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pie Chart Card with Animation
          Expanded(
            flex: 2,
            child: ScaleTransition(
              scale: Tween(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                    parent: _animationController, curve: Curves.elasticOut),
              ),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: pieData.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.pie_chart_outline,
                                size: 80,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No data available',
                              style: GoogleFonts.poppins(
                                color: AppColors.textMedium,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : EasyPieChart(
                          borderWidth: 50,
                          gap: 0,
                          size: 300,
                          borderEdge: StrokeCap.butt,
                          centerStyle: GoogleFonts.poppins(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          centerText: "Distribution",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          children: pieData,
                        ),
                ),
              ),
            ),
          ),

          // Legend with Animation
          Expanded(
            flex: 1,
            child: SlideTransition(
              position:
                  Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
                CurvedAnimation(
                    parent: _animationController, curve: Curves.easeOut),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: _buildLegend(categoryPercentages),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper method to build the legend with better design
  Widget _buildLegend(Map<String, double> categoryPercentages) {
    final filteredEntries =
        categoryPercentages.entries.where((entry) => entry.value > 0).toList();

    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[200],
        height: 1,
      ),
      itemCount: filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = filteredEntries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: _getCategoryColor(entry.key).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getCategoryColor(entry.key).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(entry.key),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getCategoryColor(entry.key).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(entry.key).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${entry.value.toStringAsFixed(1)}%",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(entry.key),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to assign colors to categories
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
}
