import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_3/components/my_button.dart';
import 'package:trabalho_3/components/my_textField.dart';
import 'package:trabalho_3/view/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  void showAlert(String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(mensagem),
        );
      },
    );
  }

  void register() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text,
          password: passwordController.text,
        );

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Navigator.pop(context);
        showAlert("As senhas não coincidem.");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'email-already-in-use') {
        showAlert("Já existe um usuário com esse e-mail.");
      } else {
        showAlert("Erro: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E7), // tom culinário quente
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 40),

              // 🍳 Ícone Temático
              const Icon(
                Icons.restaurant_menu,
                size: 100,
                color: Colors.deepOrange,
              ),

              const SizedBox(height: 20),

              // Título estilizado
              Text(
                "Crie sua conta e comece\na guardar receitas!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // Campos de Entrada
              MyTextfield(
                controller: userNameController,
                hintText: "E-mail",
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              MyTextfield(
                controller: passwordController,
                hintText: "Senha",
                obscureText: true,
              ),

              const SizedBox(height: 15),

              MyTextfield(
                controller: confirmPasswordController,
                hintText: "Confirmar senha",
                obscureText: true,
              ),

              const SizedBox(height: 25),

              // Botão de registrar
              MyButton(
                onTap: register,
                text: "Registrar",
              ),

              const SizedBox(height: 20),

              // Link para voltar ao login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tem uma conta?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
