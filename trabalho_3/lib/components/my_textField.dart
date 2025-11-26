import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int maxLines;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Color(0xFF333333), // texto escuro
            fontSize: 16,
          ),

          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: const TextStyle(
              color: Color(0xFF777777),
              fontWeight: FontWeight.w500,
            ),

            floatingLabelStyle: const TextStyle(
              color: Color(0xFFFF8A00), // laranja do seu tema
              fontWeight: FontWeight.bold,
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

            // Borda arredondada e limpa
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.orange.shade200,
                width: 1.2,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFFF8A00),
                width: 2,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.2,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
