import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: UserPage()));
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String nome = "";
  String email = "";
  String avatar = "";

  @override
  void initState() {
    super.initState();
    consultarAPI();
  }

  void consultarAPI() {
    http
        .get(
          Uri.parse("https://reqres.in/api/users/5"),
          headers: {
            'User-Agent': 'insomnia/11.0.2',
            'x-api-key': 'reqres-free-v1',
          },
        )
        .then((resposta) {
          var decodedResponse =
              jsonDecode(utf8.decode(resposta.bodyBytes)) as Map;

          var userData = decodedResponse['data'];

          setState(() {
            nome = "${userData['first_name']} ${userData['last_name']}";
            email = userData['email'];
            avatar = userData['avatar'];
          });
        })
        .catchError((erro) {
          debugPrint("Erro ao consultar API: $erro");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuário")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avatar.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                    radius: 50,
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              nome.isNotEmpty ? nome : "Carregando...",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(email.isNotEmpty ? email : ""),
          ],
        ),
      ),
    );
  }
}
