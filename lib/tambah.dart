import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahPengguna extends StatefulWidget {
  const TambahPengguna({super.key});

  @override
  State<TambahPengguna> createState() => _TambahPenggunaState();
}

class _TambahPenggunaState extends State<TambahPengguna> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? job;

  Future<void> submitData() async {
    var response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'job': job,
      }),
    );

    if (!mounted) return;
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      _showDialog('Data berhasil ditambahkan', 'ID: ${data['id']}\nDibuat pada: ${data['createdAt']}');
    } else {
      _showDialog('Error', 'Gagal menambahkan data');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon maaf, harap masukkan nama';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Pekerjaan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon maaf, harap masukkan pekerjaan';
                  }
                  return null;
                },
                onSaved: (value) {
                  job = value;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      submitData();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
