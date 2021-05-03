class Vuelo {
  String id;
  String avion;
  String itinerario;
  String finalizado;
  String precio;

  Vuelo(
      String id,
      String avion,
      String itinerario,
      String finalizado,
      String precio) {
    this.id = id;
    this.avion = avion;
    this.finalizado = finalizado;
    this.itinerario = itinerario;
    this.precio = precio;
  }

  String getAvion() {
    return this.avion;
  }

  setAvion(String avion) {
    this.avion = avion;
  }

  String geItinerario() {
    return this.avion;
  }

  setItinerario(String avion) {
    this.avion = avion;
  }

  String getFinalizado() {
    return this.avion;
  }

  setFinalizado(String avion) {
    this.avion = avion;
  }

  String getPrecio() {
    return this.avion;
  }

  setPrecio(String avion) {
    this.avion = avion;
  }
}
