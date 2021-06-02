import 'package:my_fly/model/Itinerario.dart';

import 'Avion.dart';

class Vuelo {
  int id;
  Avion avion;
  Itinerario itinerario;
  bool finalizado;
  int precio;


  Vuelo.id(
    Avion avion, 
    Itinerario itinerario, 
    bool finalizado,
    int precio) {
          
    this.avion = avion;
    this.finalizado = finalizado;
    this.itinerario = itinerario;
    this.precio = precio;
  }

  Vuelo(int id, Avion avion, Itinerario itinerario, bool finalizado,
      int precio) {
    this.id = id;
    this.avion = avion;
    this.finalizado = finalizado;
    this.itinerario = itinerario;
    this.precio = precio;
  }

  Avion getAvion() {
    return this.avion;
  }

  setAvion(Avion avion) {
    this.avion = avion;
  }

  Itinerario geItinerario() {
    return this.itinerario;
  }

  setItinerario(Itinerario itinerario) {
    this.itinerario = itinerario;
  }

  bool getFinalizadngo() {
    return this.finalizado;
  }

  setFinalizado(bool finalizado) {
    this.finalizado = finalizado;
  }

  int getPrecio() {
    return this.precio;
  }

  setPrecio(int precio) {
    this.precio = precio;
  }
}
