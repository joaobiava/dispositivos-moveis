import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_3/components/my_button.dart';
import 'package:trabalho_3/components/my_textField.dart';
import 'package:trabalho_3/components/show_alert_component.dart';
import 'package:trabalho_3/service/auth_service.dart';
import 'package:trabalho_3/view/home_page.dart';
import 'package:trabalho_3/view/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    final auth = AuthService();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await auth.signIn(
        email: userNameController.text,
        password: passwordController.text,
      );

      Navigator.of(context, rootNavigator: true).pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      switch (e.code){
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          showDialog(
            context: context,
            builder: (context) => ShowAlert(
              title: "Login error",
              message: "Incorrect Email or Password",
              icon: Icons.error_outline,
            ),
          );
          break;
        default:
          showDialog(
            context: context,
            builder: (context) => ShowAlert(
              title: "Error",
              message: "An unexpected error occurred",
              icon: Icons.error_outline,
            ),
          );
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

              const SizedBox(height: 25),

              // Botão de registrar
              MyButton(onTap: signUserIn, text: "Entrar"),

              const SizedBox(height: 20),

              // Link para voltar ao login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ainda não tem uma conta?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Cadastre-se",
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
