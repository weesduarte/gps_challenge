import 'dart:io';
import 'package:gps_challenge/helpers/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:gps_challenge/helpers/local_helper.dart';

class LocalPage extends StatefulWidget {
  Local local;

  LocalPage({this.local});

  @override
  _LocalPageState createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  ImagePicker picker = ImagePicker();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Local _editedLocal;

  @override
  void initState() {
    super.initState();

    if (widget.local == null) {
      _editedLocal = Local();
    } else {
      _editedLocal = Local.fromMap(widget.local.toMap());

      _nameController.text = _editedLocal.name;
      _addressController.text = _editedLocal.address;
      _typeController.text = _editedLocal.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2286c3),
          title: Text(_editedLocal.name ?? "Nova Localização"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedLocal.name != null && _editedLocal.name.isNotEmpty) {
              Navigator.pop(context, _editedLocal);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: const Color(0xFF2286c3),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedLocal.img != null
                          ? FileImage(File(_editedLocal.img))
                          : AssetImage("images/null.jpg"),
                    ),
                  ),
                ),
                onTap: () {
                  picker.pickImage(source: ImageSource.camera).then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedLocal.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedLocal.name = text;
                  });
                },
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Endereço"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedLocal.address = text;
                },
              ),
              TextField(
                controller: _typeController,
                decoration: InputDecoration(
                    labelText: "Tipo", prefixText: "Ex: casa, trabalho."),
                onChanged: (text) {
                  _userEdited = true;
                  _editedLocal.type = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
