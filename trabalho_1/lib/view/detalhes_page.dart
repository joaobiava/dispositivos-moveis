import 'package:flutter/material.dart';
import 'package:trabalho_1/services/animeList_service.dart';

class DetalhesPage extends StatefulWidget {
  final int id;
  const DetalhesPage({super.key, required this.id});

  @override
  State<DetalhesPage> createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  final service = AnimelistService();
  Map<String, dynamic>? anime;

  @override
  void initState() {
    super.initState();
    _buscarDetalhes();
  }

  Future<void> _buscarDetalhes() async {
    final result = await service.PesquisaAnimeById(widget.id);
    setState(() => anime = result['data']);
  }

  @override
  Widget build(BuildContext context) {
    if (anime == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          anime!['title'] ?? 'Detalhes',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  anime!['images']['jpg']['large_image_url'],
                  height: 320,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                anime!['title_english'] ??
                    anime!['title'] ??
                    'Sem título',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoChip(Icons.star, "${anime!['score'] ?? 'N/A'}"),
                SizedBox(height: 15,),
                _infoChip(Icons.play_circle_fill,
                    "${anime!['episodes'] ?? '??'} eps"),
                SizedBox(height: 15,),
                _infoChip(Icons.timeline, anime!['status'] ?? "—"),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("Sinopse"),
            _card(
              Text(
                anime!['synopsis'] ?? "Sem sinopse disponível.",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("Informações"),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoText("📁 Tipo", anime!['type']),
                  _infoText("📅 Ano", anime!['year']?.toString()),
                  _infoText("🍂 Temporada", anime!['season']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.purpleAccent,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purpleAccent),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purpleAccent, size: 20),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _infoText(String label, String? value) {
    if (value == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: $value",
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}
