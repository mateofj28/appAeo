import 'package:my_fly/model/Reserva.dart';

import 'Pago.dart';
import 'Silla.dart';
import 'Vuelo.dart';

class DetalleSillaVuelo {
  int _id;
  bool _checkIn;
  bool _pasabordo;
  dynamic _pago;
  dynamic _reserva;
  Silla _silla;
  Vuelo _vuelo;

  DetalleSillaVuelo(this._checkIn, this._pasabordo, this._pago, this._reserva,
      this._silla, this._vuelo);

  DetalleSillaVuelo.id(this._id, this._checkIn, this._pasabordo, this._pago,
      this._reserva, this._silla, this._vuelo);

  int get id => _id;
  bool get checkIn => _checkIn;
  bool get pasabordo => _pasabordo;
  Pago get pago => _pago;
  Reserva get reserva => _reserva;
  Silla get silla => _silla;
  Vuelo get vuelo => _vuelo;
}
