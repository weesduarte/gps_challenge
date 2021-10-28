import 'package:flutter/material.dart';
import 'package:gps_challenge/interface/after_start.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset("images/back.jpg", fit: BoxFit.cover, height: 1000.00),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 400.0),
            const Center(
              child: Text("Bem Vindo(a)",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontFamily: 'ScheherazadeNew')),
            ),
            Container(height: 40.0),
            Center(
              child: Container(
                  height: 42.0,
                  width: 200.0,
                  child: ElevatedButton(
                      onPressed: () => nextPage(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text("Iniciar",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0)))),
            ),
            const Spacer(),
            const Text(
              "Desenvolved by: Weslley Duarte",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          ],
        ),
      ]),
    );
  }
}

void nextPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AfterStart()),
  );
}
