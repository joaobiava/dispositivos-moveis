import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class StorageService {
  Future<String> imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);
      return "data:image/jpeg;base64,$base64Image";
    } catch (e) {
      throw Exception("Error converting image to base64: $e");
    }
  }

  Image base64ToImage(String base64String) {
    return Image.memory(
      base64Decode(base64String.split(',').last),
      fit: BoxFit.cover,
    );
  }
}