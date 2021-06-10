import 'package:my_fly/model/Pasajero.dart';

class Reserva {
  int _id;
  dynamic _pasajero;

  Reserva(this._pasajero);
  Reserva.id(this._id, this._pasajero);

  int get id => _id;
  Pasajero get pasajero => _pasajero;
}
