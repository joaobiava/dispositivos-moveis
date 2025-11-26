import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trabalho_3/components/dropdown.dart';
import 'package:trabalho_3/components/my_textField.dart';
import 'package:trabalho_3/model/recipe_model.dart';
import 'package:trabalho_3/service/firestore_service.dart';
import 'package:trabalho_3/service/storage_service.dart';

class AddEditRecipePage extends StatefulWidget {
  final Recipe? recipe;

  const AddEditRecipePage({super.key, this.recipe});

  @override
  State<AddEditRecipePage> createState() => _AddEditRecipePageState();
}

class _AddEditRecipePageState extends State<AddEditRecipePage> {
  final List<String> categorias = [
    "Sobremesa",
    "Massa",
    "Carne",
    "Lanche",
    "Bebida",
  ];

  final List<String> dificuldades = ["Fácil", "Médio", "Difícil"];

  final _formKey = GlobalKey<FormState>();
  final FirestoreService firestoreService = FirestoreService();
  final StorageService storageService = StorageService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String? selectedCategory;

  final TextEditingController difficultyController = TextEditingController();
  String? selectedDifficulty;

  final TextEditingController timeController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController prepareController = TextEditingController();
  final TextEditingController portionsController = TextEditingController();
  String imageBase64 = "";

  @override
  void initState() {
    super.initState();

    if (widget.recipe != null) {
      final r = widget.recipe!;

      nameController.text = r.name;
      selectedCategory = r.category;
      categoryController.text = r.category;

      timeController.text = r.time;

      selectedDifficulty = r.difficulty;
      difficultyController.text = r.difficulty;

      ingredientsController.text = r.ingredients;
      prepareController.text = r.prepare;
      portionsController.text = r.portions;
      imageBase64 = r.image ?? "";
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      imageBase64 = await storageService.imageToBase64(File(file.path));
      setState(() {});
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    final recipe = Recipe(
      id: widget.recipe?.id,
      name: nameController.text,
      category: categoryController.text,
      time: timeController.text,
      difficulty: difficultyController.text,
      ingredients: ingredientsController.text,
      prepare: prepareController.text,
      portions: portionsController.text,
      image: imageBase64,
    );

    if (widget.recipe == null) {
      await firestoreService.create(recipe);
    } else {
      await firestoreService.update(recipe.id!, recipe);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8A00),
        title: Text(
          widget.recipe == null ? "Adicionar Receita" : "Editar Receita",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),

      backgroundColor: const Color(0xFFF7F3EF),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              // CARD DA IMAGEM
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.orange.shade100.withOpacity(0.6),
                  ),
                  height: 180,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageBase64.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Color(0xFF444444),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Selecionar imagem",
                                style: TextStyle(
                                  color: Color(0xFF444444),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : storageService.base64ToImage(imageBase64),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CARD BRANCO COM OS CAMPOS
              Card(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      MyTextfield(
                        controller: nameController,
                        hintText: "Nome da receita",
                        obscureText: false,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "preencha este campo"
                                : null,
                      ),

                      Dropdown(
                        label: "Selecione uma categoria",
                        items: categorias,
                        value: selectedCategory,
                        color: const Color(0xFFFF8A00),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                            categoryController.text = value ?? "";
                          });
                        },
                      ),

                      MyTextfield(
                        controller: timeController,
                        hintText: "Tempo de preparo (minutos)",
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o tempo";
                          }
                          int? num = int.tryParse(value);
                          if (num == null) {
                            return "Número não pode ser nulo";
                          }
                          if (num < 1 || num > 160) {
                            return "o tempo deve estar entre 1 e 160";
                          }
                          return null;
                        },
                      ),

                      Dropdown(
                        label: "Dificuldade",
                        items: dificuldades,
                        value: selectedDifficulty,
                        color: const Color(0xFFFF8A00),
                        onChanged: (value) {
                          setState(() {
                            selectedDifficulty = value;
                            difficultyController.text = value ?? "";
                          });
                        },
                      ),

                      MyTextfield(
                        controller: ingredientsController,
                        hintText: "Ingredientes",
                        obscureText: false,
                        maxLines: 8,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "preencha este campo"
                                : null,
                      ),

                      MyTextfield(
                        controller: prepareController,
                        hintText: "Modo de preparo",
                        obscureText: false,
                        maxLines: 8,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? "preencha este campo"
                                : null,
                      ),

                      MyTextfield(
                        controller: portionsController,
                        hintText: "Porções",
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe as porções";
                          }

                          double? num = double.tryParse(value);
                          if (num == null) {
                            return "Digite apenas números";
                          }

                          if (num < 1 || num > 10) {
                            return "O valor deve estar entre 1 e 10";
                          }

                          if (num % 0.5 != 0) {
                            return "Se for número quebrado, use .5";
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    widget.recipe == null ? "Salvar Receita" : "Atualizar Receita",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
