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
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 58, bottom: 150, right: 0, left: 0),
              child: Text("Hi Geo!",
                  style: TextStyle(fontSize: 34, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 30, left: 0, right: 0),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/view_receipts');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0.0,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'View Receipts',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(250, 200),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.amberAccent,
                child: InkWell(
                  splashColor: Colors.lightBlue,
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
            ),
          ],
        ),
      ),
    );
  }
}
