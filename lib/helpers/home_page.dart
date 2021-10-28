import 'dart:io';
import 'package:gps_challenge/interface/after_start.dart';
import 'package:flutter/material.dart';
import 'package:gps_challenge/helpers/local_helper.dart';
import 'package:gps_challenge/helpers/local_edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocalHelper helper = LocalHelper();
  List<Local> locals = List();

  @override
  void initState() {
    super.initState();
    getAllLocals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AfterStart()),
            );
          },
        ),
        backgroundColor: const Color(0xFF2286c3),
        title: const Text("Locais"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLocalPage();
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF2286c3),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: locals.length,
          itemBuilder: (context, index) {
            return _localCard(context, index);
          }),
    );
  }

  Widget _localCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: locals[index].img != null
                          ? FileImage(File(locals[index].img))
                          : const AssetImage("images/null.jpg")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locals[index].name ?? "",
                        style: const TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        locals[index].address ?? "",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        locals[index].type ?? "",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showLocalPage({Local local}) async {
    final recLocal = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocalPage(
                local: local,
              )),
    );
    if (recLocal != null) {
      if (local != null) {
        await helper.updateLocal(recLocal);
      } else {
        await helper.saveLocal(recLocal);
      }
      getAllLocals();
    }
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showLocalPage(local: locals[index]);
                        },
                        child: const Text(
                          "Editar",
                          style: TextStyle(
                              color: Color(0xFF2286c3), fontSize: 20.0),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                        onPressed: () {
                          helper.deleteLocal(locals[index].id);
                          setState(() {
                            locals.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Excluir",
                          style: TextStyle(
                              color: Color(0xFF2286c3), fontSize: 20.0),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FlatButton(
                        onPressed: () {},
                        child: const Text(
                          "Planejar Rota",
                          style: TextStyle(
                              color: Color(0xFF2286c3), fontSize: 20.0),
                        )),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void getAllLocals() {
    helper.getAllLocals().then((list) {
      setState(() {
        locals = list;
      });
    });
  }
}
