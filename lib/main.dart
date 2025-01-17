import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const scaffoldBackgroundColor = Colors.black;
const commonFontColor = Color.fromARGB(255, 255, 248, 225);
const seedColor = Color.fromARGB(255, 255, 236, 179);
const checkColor = Color.fromARGB(255, 100, 100, 100);
const borderColor = Color.fromARGB(255, 255, 236, 179);
const fabColor = Color.fromARGB(255, 255, 224, 130);
const bottomSheetBackgroundColor = Color.fromARGB(255, 30, 30, 30);
const inputHintColor = Color.fromARGB(255, 135, 135, 120);
const buttonForegroundColor = Color.fromARGB(255, 85, 85, 70);

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
      locale: const Locale('en', 'IN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('en', 'IN'),
      ],
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.outfitTextTheme(const TextTheme()),
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        checkboxTheme: const CheckboxThemeData(
            checkColor: WidgetStatePropertyAll(checkColor),
            shape: CircleBorder(),
            visualDensity: VisualDensity(horizontal: -2, vertical: -2)),
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
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
            visualDensity: VisualDensity(horizontal: -1.5, vertical: -1.5),
          ),
        ),
        dialogTheme:
            const DialogTheme(backgroundColor: bottomSheetBackgroundColor),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(commonFontColor),
            foregroundColor: WidgetStatePropertyAll(buttonForegroundColor),
            padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
            minimumSize: WidgetStatePropertyAll(
              Size(70, 40),
            ),
            maximumSize: WidgetStatePropertyAll(
              Size(70, 40),
            ),
          ),
        ),
        useMaterial3: true,
      ),
    );
  }
}
