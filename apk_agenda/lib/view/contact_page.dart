import 'dart:io';
import 'package:apk_agenda/database/helper/contact_helper.dart';
import 'package:apk_agenda/database/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imgController = TextEditingController();
  final ContactHelper _helper = ContactHelper();
  final ImagePicker _picker = ImagePicker();
  final phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####', 
    filter: {'#': RegExp(r'[0-9]')}
  );

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editContact = Contact(name: "", email: "", phone: "", img: "");
    } else {
      _editContact = widget.contact;
      _nameController.text = _editContact?.name ?? "";
      _emailController.text = _editContact?.email ?? "";
      _phoneController.text = _editContact?.phone ?? "";
      _imgController.text = _editContact?.img ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_editContact?.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveContact();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => _selectImage(),
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        _editContact?.img != null &&
                            _editContact!.img!.isNotEmpty
                        ? FileImage(File(_editContact!.img!))
                        : AssetImage("assets/imgs/avatar.png") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) => {
                _userEdited = true,
                setState(() {
                  _editContact?.name = text;
                }),
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) => {
                _userEdited = true,
                setState(() {
                  _editContact?.email = text;
                }),
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Telefone"),
              onChanged: (text) => {
                _userEdited = true,
                setState(() {
                  _editContact?.phone = text;
                }),
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneMask],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _editContact?.img = image.path;
      });
    }
  }

  void _saveContact() async {
    if (_editContact?.img == "") {
      _editContact?.img = null;
    }

    if (_editContact?.name != null && _editContact!.name.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
      
      // Verificação de email
      if (!emailRegex.hasMatch(_editContact!.email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("E-mail inválido")),
        );
        return;
      }

      // Verificação de telefone
      if (_editContact!.phone.length < 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Telefone inválido!")),
        );
        return;
      }

      if (_editContact?.id != null) {
        await _helper.updateContact(_editContact!);
      } else {
        await _helper.saveContact(_editContact!);
      }

      Navigator.pop(context, _editContact);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Nome é Obrigatório")));
    }
  }
}
