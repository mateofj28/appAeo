class Pasajero {
  String _nombre, _apellido, _cedula, _telefono, _correo, _contrasena;

  Pasajero(this._cedula, this._nombre, this._apellido, this._telefono, this._correo,
      this._contrasena);

  String get nombre => this._nombre;
  String get apellido => this._apellido;
  String get cedula => this._cedula;
  String get telefono => this._telefono;
  String get correo => this._correo;
  String get contrasena => this._contrasena;
    
}
