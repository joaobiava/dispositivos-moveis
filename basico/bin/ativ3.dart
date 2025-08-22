import 'dart:math';

enum Naipe{
  copas, ouro, espada, paus
}

enum Valor{
  as, dois, tres, quatro, cinco, seis, sete, oito, nove, dez, valete, dama, rei
}

class Card{
  final Naipe naipe;
  final Valor valor; 

  Card(this.naipe, this.valor);

  @override
  String toString() {
    return "${valor.name} de ${naipe.name}";
  }

}

class Baralho{
  List<Card> cartas = [];

  Baralho(){
    for(var naipe in Naipe.values){
      for(var valor in Valor.values){
        cartas.add(Card(naipe, valor));
      }
    }
  }

  @override
  String toString(){
    return "$cartas";
  }

  void embaralhar(){
    cartas.shuffle(Random());
  }

  void comprar(){
    print(cartas.last);
    cartas.remove(cartas.last);
  }

  void cartasRestantes(){
    int i = 0;
    while(i < cartas.length){
      i++;
    }
    print("o baralho possui $i cartas restantes");
  }

}

void main (List<String> arguments){
  Card carta1 = Card(Naipe.copas, Valor.as);
  print(carta1);

  Baralho baralho = Baralho();
  print(baralho);
  baralho.embaralhar();
  print(baralho);
  baralho.comprar();
  baralho.comprar();
  baralho.comprar();
  baralho.comprar();
  baralho.comprar();
  baralho.cartasRestantes();
}