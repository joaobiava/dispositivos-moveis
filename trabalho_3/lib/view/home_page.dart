import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_3/components/dropdown.dart';
import 'package:trabalho_3/model/recipe_model.dart';
import 'package:trabalho_3/service/firestore_service.dart';
import 'package:trabalho_3/service/storage_service.dart';
import 'addEditRecipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String filtro = "Nome";

  final List<String> opcoesFiltro = [
    "Nome",
    "Categoria",
    "Tempo",
    "Dificuldade",
  ];

  final FirestoreService firestoreService = FirestoreService();
  final StorageService storageService = StorageService();

  // ----------- ORDENAR LISTA -----------
  void ordenarLista(List<Recipe> recipes) {
    switch (filtro) {
      case "Nome":
        recipes.sort((a, b) => a.name.compareTo(b.name));
        break;

      case "Categoria":
        recipes.sort((a, b) => a.category.compareTo(b.category));
        break;

      case "Tempo":
        recipes.sort((a, b) => int.parse(a.time).compareTo(int.parse(b.time)));
        break;

      case "Dificuldade":
        recipes.sort((a, b) => a.difficulty.compareTo(b.difficulty));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        elevation: 3,
        title: const Text(
          "Minhas Receitas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade700,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditRecipePage()),
          );
        },
      ),

      body: StreamBuilder<List<Recipe>>(
        stream: firestoreService.read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Nenhuma receita cadastrada ainda.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final recipes = snapshot.data!;
          ordenarLista(recipes);

          return Column(
            children: [
              // FILTRO
              Padding(
                padding: const EdgeInsets.all(16),
                child: Dropdown(
                  label: "Ordenar por:",
                  items: opcoesFiltro,
                  value: filtro,
                  onChanged: (value) {
                    setState(() {
                      filtro = value!;
                    });
                  },
                ),
              ),

              // LISTA
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipes.length,
                  itemBuilder: (context, i) {
                    final recipe = recipes[i];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Card(
                        elevation: 6,
                        color: Colors.white,
                        shadowColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditRecipePage(recipe: recipe),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // IMAGEM
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: recipe.image != null &&
                                          recipe.image!.isNotEmpty
                                      ? SizedBox(
                                          width: 90,
                                          height: 90,
                                          child: storageService.base64ToImage(
                                            recipe.image!,
                                          ),
                                        )
                                      : Container(
                                          width: 90,
                                          height: 90,
                                          color: Colors.orange.shade100,
                                          child: Icon(
                                            Icons.fastfood,
                                            size: 45,
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                ),

                                const SizedBox(width: 16),

                                // TEXTOS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade800,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${recipe.category} • ${recipe.time} min",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // BOTÃO DELETAR
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade300,
                                  ),
                                  onPressed: () async {
                                    await confirmarExclusao(
                                      context,
                                      recipe.id!,
                                      firestoreService,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // CONFIRMAR EXCLUSÃO
  Future<void> confirmarExclusao(
    BuildContext context,
    String recipeId,
    FirestoreService firestore,
  ) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Receita"),
          content: const Text("Tem certeza que deseja excluir esta receita?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade300,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Excluir",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await firestore.delete(recipeId);
    }
  }
}
