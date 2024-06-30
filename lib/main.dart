import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  // final appDocumentDirectory =
  //     await path_provider.getApplicationDocumentsDirectory();
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
          seedColor: Colors.amber.shade100,
        ),
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.black,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber[200],
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.amber[200],
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: const WidgetStatePropertyAll(
            Color.fromARGB(255, 100, 100, 100),
          ),
          fillColor: WidgetStateProperty.all(Colors.black),
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const BorderSide(
                width: 1.5,
                color: Colors.black,
              ); // Border color when checked
            }
            return BorderSide(
              width: 1.5,
              color: Colors.amber[50] ?? Colors.amber,
            ); // Border color when unchecked
          }),
          shape: const CircleBorder(),
        ),
        useMaterial3: true,
      ),
    );
  }
}
