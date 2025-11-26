import 'package:flutter/material.dart';
import 'package:trabalho_2/database/helper/recipe_helper.dart';
import 'package:trabalho_2/database/model/recipe_model.dart';
import 'package:trabalho_2/view/addRecipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RecipeHelper helper = RecipeHelper();
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final list = await helper.getAllrecipes();
    setState(() {
      recipes = list;
    });
  }

  void _confirmDelete(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Receita"),
          content: Text("Tem certeza que deseja excluir '${recipe.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await helper.deleteRecipe(recipe.id!);
                Navigator.pop(context);
                _loadRecipes(); // Atualiza lista
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
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
        title: const Text("📖 Livro de Receitas"),
        backgroundColor: Colors.amber[300],
        centerTitle: true,
      ),
      backgroundColor: Colors.brown[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // abre a tela de adicionar e aguarda o retorno
          final adicionou = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipePage()),
          );

          // se a tela de adicionar retornou true, recarrega a lista
          if (adicionou == true) {
            _loadRecipes();
          }
        },
        backgroundColor: Colors.amber[400],
        child: const Icon(Icons.add),
      ),

      body: recipes.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma receita cadastrada",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return _recipeCard(context, recipes[index]);
              },
            ),
    );
  }

  Widget _recipeCard(BuildContext context, Recipe recipe) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Quando clicar em qualquer parte (exceto nos botões), abre os detalhes
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailsPage(recipe: recipe),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Ícone circular (ou futura imagem)
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: const Icon(Icons.restaurant_menu, size: 40),
              ),
              const SizedBox(width: 16),

              // Informações e botões
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome + botões lado a lado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name ?? "Sem nome",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: "Editar",
                              onPressed: () async {
                                final editou = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddRecipePage(recipe: recipe),
                                  ),
                                );
                                if (editou == true) {
                                  _loadRecipes();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: "Excluir",
                              onPressed: () => _confirmDelete(context, recipe),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      recipe.category ?? "Sem categoria",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recipe.portions != null
                          ? "${recipe.portions} porções"
                          : "Sem porções",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "⏱️ ${recipe.time} minutos" ?? 'Tempo não informado',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        elevation: 0,
        title: Text(
          "Detalhes da Receita",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                recipe.name ?? "Sem nome",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ------------------ INFORMAÇÕES RÁPIDAS ------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoChip(Icons.category, recipe.category ?? "Sem categoria"),
                _infoChip(Icons.timer, recipe.time ?? "Sem tempo"),
                _infoChip(Icons.leaderboard, recipe.difficulty ?? "N/A"),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ------------------ INGREDIENTES ------------------
          _sectionTitle("Ingredientes"),
          _sectionCard(recipe.ingredients ?? "Sem ingredientes"),

          const SizedBox(height: 25),

          // ------------------ MODO DE PREPARO ------------------
          _sectionTitle("Modo de preparo"),
          _sectionCard(recipe.prepare ?? "Sem instruções"),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // WIDGETS DE APOIO
  // -----------------------------------------------------------

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.amber[800]),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionCard(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.4)),
    );
  }
}
