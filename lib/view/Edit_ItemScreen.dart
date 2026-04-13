import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:expense_app_tracker/widgets/Constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditItemscreen extends StatefulWidget {
  const EditItemscreen({super.key});

  @override
  State<EditItemscreen> createState() => _EditItemscreenState();
}

class _EditItemscreenState extends State<EditItemscreen>
    with SingleTickerProviderStateMixin {
  late String selectedCategoryLocal;
  late AnimationController _animationController;

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

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
          'Edit Expense',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: cubit.FormKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Animated Form Card
                SlideTransition(
                  position: Tween(begin: const Offset(0, 0.3), end: Offset.zero)
                      .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.12),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          // Item Name Field
                          _buildFormField(
                            controller: cubit.itemNameController,
                            label: 'Item Name',
                            icon: Icons.shopping_cart,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the item name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // Item Price Field
                          _buildFormField(
                            controller: cubit.itemPriceController,
                            label: 'Item Price (\$)',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the item price';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // Category Dropdown
                          _buildCategoryDropdown(cubit),
                          const SizedBox(height: 18),

                          // Date Field
                          _buildDateField(cubit),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Update Expense Button
                _buildSubmitButton(cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.dangerRed,
            width: 1,
          ),
        ),
        prefixIcon: Icon(icon, color: AppColors.accent),
        label: Text(label),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textMedium,
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }

  Widget _buildCategoryDropdown(AppCubit cubit) {
    return StatefulBuilder(
      builder: (context, innerSetState) => DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.category, color: AppColors.accent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.accent,
              width: 2,
            ),
          ),
          label: Text(
            'Select Category',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        value: selectedCategoryLocal,
        items: cubit.categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
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
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildDateField(AppCubit cubit) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter the item date';
        }
        return null;
      },
      controller: cubit.itemDateController,
      readOnly: true,
      onTap: () => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(DateTime.now().year + 10),
      ).then((value) {
        if (value != null) {
          cubit.itemDateController.text = DateFormat.yMMMMd().format(value);
        }
      }),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
        prefixIcon: const Icon(Icons.calendar_today, color: AppColors.accent),
        label: Text(
          'Item Date',
          style: GoogleFonts.poppins(
            color: AppColors.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      keyboardType: TextInputType.none,
    );
  }

  Widget _buildSubmitButton(AppCubit cubit) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.accent.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (cubit.FormKey.currentState!.validate()) {
              cubit
                  .updateDataInDatabase(
                id: cubit.editedetemId,
                title: cubit.itemNameController.text,
                price: double.parse(cubit.itemPriceController.text),
                date: cubit.itemDateController.text,
                category: selectedCategoryLocal,
              )
                  .then((value) {
                cubit.clearControllers();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    closeIconColor: Colors.white,
                    showCloseIcon: true,
                    backgroundColor: AppColors.accent,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    content: Text(
                      "Expense updated successfully!",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
                Navigator.pop(context);
              });
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Text(
              'Update Expense',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
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
