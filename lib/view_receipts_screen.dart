import 'package:flutter/material.dart';

class ViewReceiptsScreen extends StatelessWidget {
  const ViewReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Saver"),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text("This will be where the receipts will be visible.",
                  style: TextStyle(fontSize: 34, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }


}
