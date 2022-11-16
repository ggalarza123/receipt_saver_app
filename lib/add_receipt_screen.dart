import 'package:flutter/material.dart';

class AddReceiptScreen extends StatelessWidget {
  const AddReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Saver"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {},
              child: Container(
                color: Colors.lightBlue,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  'Save Image',
                  style: TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(250, 250),
              child: Material(
                color: Colors.amberAccent,
                child: InkWell(
                  splashColor: Colors.green,
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo,
                        size: 200,
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
