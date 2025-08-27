import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  final TextEditingController _controller = TextEditingController();
  int? _userId;

  Future<void> consultarAPI(int id) async {
    try {
      final resposta = await http.get(
        Uri.parse("https://reqres.in/api/users/$id"),
        headers: {
          'User-Agent': 'insomnia/11.0.2',
          'x-api-key': 'reqres-free-v1',
        },
      );

      if (resposta.statusCode == 200) {
        final decodedResponse =
            jsonDecode(utf8.decode(resposta.bodyBytes)) as Map;

        final userData = decodedResponse['data'];

        setState(() {
          nome = "${userData['first_name']} ${userData['last_name']}";
          email = userData['email'];
          avatar = userData['avatar'];
        });
      } else {
        setState(() {
          nome = "Usuário não encontrado";
          email = "";
          avatar = "";
        });
      }
    } catch (erro) {
      debugPrint("Erro ao consultar API: $erro");
      setState(() {
        nome = "Erro ao consultar API";
        email = "";
        avatar = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuário")),
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Digite o ID do usuário (1 a 12)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(_controller.text);
                if (value != null && value >= 1 && value <= 12) {
                  _userId = value;
                  consultarAPI(value);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Digite um número válido entre 1 e 12"),
                    ),
                  );
                }
              },
              child: const Text("Buscar Usuário"),
            ),
            const SizedBox(height: 30),
            avatar.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                    radius: 50,
                  )
                : const Icon(Icons.person, size: 80),
            const SizedBox(height: 20),
            Text(
              nome.isNotEmpty ? nome : "Nenhum usuário carregado",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(email.isNotEmpty ? email : ""),
          ],
        ),
      ),
    );
  }
}
