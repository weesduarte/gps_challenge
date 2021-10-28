import 'dart:io';
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
  final _addressFocus = FocusNode();

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
            if (_editedLocal.address != null &&
                _editedLocal.address.isNotEmpty) {
              Navigator.pop(context, _editedLocal);
            } else {
              FocusScope.of(context).requestFocus(_addressFocus);
            }
          },
          child: const Icon(Icons.save),
          backgroundColor: const Color(0xFF2286c3),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
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
                          : const AssetImage("images/null.jpg"),
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
                decoration: const InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedLocal.name = text;
                  });
                },
              ),
              TextField(
                controller: _addressController,
                focusNode: _addressFocus,
                decoration: const InputDecoration(labelText: "Endereço"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedLocal.address = text;
                },
              ),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
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
              title: const Text("Descartar Alterações?"),
              content: const Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: const Text("Sim"),
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
