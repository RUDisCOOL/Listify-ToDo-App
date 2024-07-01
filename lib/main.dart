import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

const tileBackgroundColor = Colors.black;
const scaffoldBackgroundColor = Colors.black;
const commonFontColor = Color.fromARGB(255, 255, 248, 225);
const seedColor = Color.fromARGB(255, 255, 236, 179);
const checkColor = Color.fromARGB(255, 100, 100, 100);
const borderColor = Color.fromARGB(255, 255, 236, 179);
const fabColor = Color.fromARGB(255, 255, 224, 130);
const bottomSheetBackgroundColor = Color.fromARGB(255, 30, 30, 30);
const inputHintColor = Color.fromARGB(255, 135, 135, 120);

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myTasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        cardColor: tileBackgroundColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: fabColor,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: const WidgetStatePropertyAll(checkColor),
          fillColor: WidgetStateProperty.all(tileBackgroundColor),
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const BorderSide(
                width: 1.5,
                color: tileBackgroundColor,
              );
            }
            return const BorderSide(
              width: 1.5,
              color: borderColor,
            );
          }),
          shape: const CircleBorder(),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: commonFontColor,
          backgroundColor: scaffoldBackgroundColor,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: bottomSheetBackgroundColor,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: inputHintColor),
        ),
        useMaterial3: true,
      ),
    );
  }
}
