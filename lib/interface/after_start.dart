import 'package:flutter/material.dart';
import 'package:gps_challenge/helpers/home_page.dart';
import 'package:gps_challenge/interface/home.dart';
import 'package:gps_challenge/map/map_page.dart';

class AfterStart extends StatelessWidget {
  const AfterStart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
          icon: const Icon(Icons.cottage),
        ),
        backgroundColor: const Color(0xFF2286c3),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://media2.giphy.com/media/d2jjuAZzDSVLZ5kI/200w.webp?cid=ecf05e47gcnwcz38nffb1z6c3sbvhj2fgq2b5q0ah5ms7ijb&rid=200w.webp&ct=g"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 240.0,
            ),
            Center(
              child: Container(
                height: 50.0,
                width: 250.0,
                child: ElevatedButton(
                    onPressed: () => _newLocal(context),
                    style: ElevatedButton.styleFrom(
                      primary: (const Color(0xFF49599a)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text("Nova Localização",
                        style: TextStyle(color: Colors.black, fontSize: 20.0))),
              ),
            ),
            Container(height: 30.0),
            const Text(
              "Ou",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            Container(height: 30.0),
            Center(
              child: Container(
                height: 50.0,
                width: 250.0,
                child: ElevatedButton(
                    onPressed: () => toLocalPage(context),
                    style: ElevatedButton.styleFrom(
                      primary: (const Color(0xFF49599a)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text("Localizações Salvas",
                        style: TextStyle(color: Colors.black, fontSize: 20.0))),
              ),
            ),
            const Spacer(flex: 1),
            const Text(
              "Desenvolved by: Weslley Duarte",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}

void _newLocal(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MapPage()),
  );
}

void toLocalPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}
