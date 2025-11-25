import 'package:flutter/material.dart';
import 'package:trabalho_1/services/animeList_service.dart';
import 'package:trabalho_1/view/detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = AnimelistService();

  String? campo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 4,
        centerTitle: true,
        title: const Text(
          "Buscador de Animes",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            TextField(
              decoration: InputDecoration(
                hintText: "Buscar anime...",
                hintStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.grey.shade900,
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.purple.shade700, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),


            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder(
                future: service.PesquisaAnimeByName(campo),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purpleAccent,
                              ),
                              strokeWidth: 4,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Buscando...",
                              style: TextStyle(color: Colors.white70),
                            )
                          ],
                        ),
                      );

                    default:
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Erro ao carregar resultados",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        );
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    List<dynamic> animes = [];

    if (snapshot.data is Map && snapshot.data['data'] is List) {
      animes = snapshot.data['data'] as List<dynamic>;
    } else {
      return const Center(
        child: Text(
          "Formato de dados da API inesperado. Verifique o serviço.",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (animes.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum anime encontrado!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: animes.length,
      itemBuilder: (context, index) {
        var anime = animes[index];

        var id = anime["mal_id"] ?? "nao possui id";
        var titulo = anime['title'] ?? "Sem título";
        var sinopse = anime['synopsis'] ?? 'Sinopse não disponível.';
        var imageUrl =
            anime['images']?['jpg']?['image_url'] ??
            'https://via.placeholder.com/60x80/222222/FFFFFF?text=NO+IMG';
        var pontos = anime['score']?.toString() ?? "N/A";
        var episodios = anime["episodes"]?.toString() ?? "Desconhecido";

        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.white54,
                ),
              ),
            ),

            title: Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '⭐ $pontos | 🎬 $episodios episódios',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sinopse,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetalhesPage(id: id)),
              );
            },
          ),
        );
      },
    );
  }
}
