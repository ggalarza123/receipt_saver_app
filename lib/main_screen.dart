import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // Displays to the user two options, View Receipts or Add Receipts
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Receipt Saver")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Hi Geo!",
                style: TextStyle(fontSize: 34, color: Colors.black)),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/view_receipts');
              },
              child: Container(
                color: Colors.lightBlue,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  'View Receipts',
                  style: TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(250, 250),
              child: Material(
                color: Colors.amberAccent,
                child: InkWell(
                  splashColor: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/add_receipt');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("Add Receipt",
                          style: TextStyle(fontSize: 24, color: Colors.black)),
                      Icon(
                        Icons.add_a_photo,
                        size: 100,
                      ), // <-- Icon
                      // <-- Text
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
