import 'package:flutter/material.dart';
import 'package:receipt_saver_app/main_screen.dart';
import './add_receipt_screen.dart';
import './view_receipts_screen.dart';

void main() {
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
        '/': (context) => const MainScreen(), //
        '/add_receipt' : (context) => const AddReceiptScreen(),
        '/view_receipts' : (context) => const ViewReceiptsScreen()
      },
    );
  }

}
