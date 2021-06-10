import 'package:my_fly/model/Pasajero.dart';

class Pago {
  int _id;
  int _codigoSegurida;
  int _fechaExpedicion;
  String _nombreTitular;
  int _numeroTarjeta;
  int _valor;
  dynamic _cliente;

  Pago(this._codigoSegurida, this._fechaExpedicion, this._nombreTitular,
      this._numeroTarjeta, this._valor, this._cliente);

  Pago.id(this._id, this._codigoSegurida, this._fechaExpedicion,
      this._nombreTitular, this._numeroTarjeta, this._valor, this._cliente);

  int get id => _id;
  int get codigoSegurida => _codigoSegurida;
  int get fechaExpedicion => _fechaExpedicion;
  String get nombreTitular => _nombreTitular;
  int get numeroTarjeta => _numeroTarjeta;
  int get valor => _valor;
  Pasajero get cliente => _cliente;
}
