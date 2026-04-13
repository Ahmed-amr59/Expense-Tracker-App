import 'package:expense_app_tracker/view/HomeScreen.dart';
import 'package:expense_app_tracker/view_model/Cubit.dart';
import 'package:expense_app_tracker/view_model/States.dart';
import 'package:expense_app_tracker/view_model/observer.dart';
import 'package:expense_app_tracker/widgets/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          home: const MyApp(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.dangerRed,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.dangerRed,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              labelStyle: GoogleFonts.poppins(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: GoogleFonts.poppins(
                color: AppColors.textLight,
                fontWeight: FontWeight.w400,
              ),
              prefixIconColor: AppColors.primary,
            ),
            textTheme: TextTheme(
              headlineLarge: AppTextStyles.headingLarge(),
              headlineMedium: AppTextStyles.headingMedium(),
              headlineSmall: AppTextStyles.headingSmall(),
              bodyLarge: AppTextStyles.bodyLarge(),
              bodyMedium: AppTextStyles.bodyMedium(),
              bodySmall: AppTextStyles.bodySmall(),
              labelLarge: AppTextStyles.labelLarge(),
              labelMedium: AppTextStyles.labelMedium(),
            ),
          ),
        ),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
