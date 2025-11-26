import 'package:flutter/material.dart';
import 'package:trabalho_2/database/helper/recipe_helper.dart';
import 'package:trabalho_2/database/model/recipe_model.dart';

class AddRecipePage extends StatefulWidget {
  final Recipe? recipe;

  const AddRecipePage({super.key, this.recipe});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final RecipeHelper helper = RecipeHelper();
  String? selectedCategory;
  String? selectedDifficulty;

  // controladores dos campos
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController prepareController = TextEditingController();
  final TextEditingController portionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      nameController.text = widget.recipe!.name ?? '';
      categoryController.text = widget.recipe!.category ?? '';
      timeController.text = widget.recipe!.time ?? '';
      difficultyController.text = widget.recipe!.difficulty ?? '';
      ingredientsController.text = widget.recipe!.ingredients ?? '';
      prepareController.text = widget.recipe!.prepare ?? '';
      portionsController.text = widget.recipe!.portions?.toString() ?? '';

      selectedCategory = widget.recipe!.category;      // deixa o dropdown preenchido
      selectedDifficulty = widget.recipe!.difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Receita"),
        backgroundColor: Colors.amber[300],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Título
              Text(
                widget.recipe == null ? "Adicionar Receita" : "Editar Receita",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),

              // Card principal
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      
                      // Nome
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Nome da receita",
                          prefixIcon: const Icon(Icons.restaurant_menu),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "O nome não pode ficar em branco.";
                          }
                          if (value.trim().length < 3) {
                            return "O nome deve ter pelo menos 3 caracteres.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Categoria
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: "Categoria",
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Comida', child: Text('Comida')),
                          DropdownMenuItem(value: 'Bebida', child: Text('Bebida')),
                        ],
                        onChanged: (v) {
                          setState(() {
                            selectedCategory = v;
                            categoryController.text = v!;
                          });
                        },
                        validator: (v) =>
                            v == null ? "Selecione uma categoria" : null,
                      ),
                      const SizedBox(height: 16),

                      // Tempo
                      TextFormField(
                        controller: timeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Tempo de preparo (min)",
                          prefixIcon: const Icon(Icons.timer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe o tempo de preparo.";
                          }
                          final temp = int.tryParse(value);
                          if (temp == null || temp < 1 || temp > 160) {
                            return "Digite entre 1 e 160 minutos.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Dificuldade
                      DropdownButtonFormField<String>(
                        value: selectedDifficulty,
                        decoration: InputDecoration(
                          labelText: "Dificuldade",
                          prefixIcon: const Icon(Icons.leaderboard),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Fácil', child: Text('Fácil')),
                          DropdownMenuItem(value: 'Médio', child: Text('Médio')),
                          DropdownMenuItem(value: 'Difícil', child: Text('Difícil')),
                        ],
                        onChanged: (v) {
                          setState(() {
                            selectedDifficulty = v;
                            difficultyController.text = v!;
                          });
                        },
                        validator: (v) =>
                            v == null ? "Selecione a dificuldade." : null,
                      ),
                      const SizedBox(height: 16),

                      // Ingredientes
                      TextFormField(
                        controller: ingredientsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Ingredientes",
                          prefixIcon: const Icon(Icons.list_alt),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Informe os ingredientes.";
                          }
                          return null;
                        }

                      ),
                      const SizedBox(height: 16),

                      // Preparo
                      TextFormField(
                        controller: prepareController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Modo de preparo",
                          prefixIcon: const Icon(Icons.soup_kitchen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Informe o modo de preparo.";
                          }
                          return null;
                        }

                      ),
                      const SizedBox(height: 16),

                      // Porções
                      TextFormField(
                        controller: portionsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Porções",
                          prefixIcon: const Icon(Icons.people),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Informe as porções.";
                          }
                          final num = double.tryParse(value);
                          if (num == null || num <= 0 || num > 10) {
                            return "Digite um número válido entre 1 e 10.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveRecipe,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Salvar Receita",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )

    );
  }

  void _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return; // impede salvar se houver erros
    }

    if (widget.recipe == null) {
      if (_formKey.currentState!.validate()) {
        Recipe recipe = Recipe(
          name: nameController.text,
          category: categoryController.text,
          time: timeController.text,
          difficulty: difficultyController.text,
          ingredients: ingredientsController.text,
          prepare: prepareController.text,
          portions:
              double.tryParse(portionsController.text) ?? 0.0, // evita erro
        );

        await helper.saveRecipe(recipe);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receita salva com sucesso!')),
          );
          Navigator.pop(context, true); // volta e indica sucesso
        }
      }
    } else {
      final updated = Recipe(
        id: widget.recipe!.id,
        name: nameController.text,
        category: categoryController.text,
        time: timeController.text,
        difficulty: difficultyController.text,
        ingredients: ingredientsController.text,
        prepare: prepareController.text,
        portions: double.tryParse(portionsController.text) ?? 0.0,
      );

      await helper.updateRecipe(updated);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita atualizada com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    }
  }
}
