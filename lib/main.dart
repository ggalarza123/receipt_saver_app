import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:receipt_saver_app/main_screen.dart';
import './add_receipt_screen.dart';
import './view_receipts_screen.dart';

void main() async {
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Saver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // sets the initial screen to MainScreen
        '/': (context) => const MainScreen(), //
        '/add_receipt': (context) => AddReceiptScreen(),
        '/view_receipts': (context) => ViewReceiptsScreen()
      },
    );
  }
}
