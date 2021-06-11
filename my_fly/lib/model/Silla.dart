import 'package:my_fly/model/ClaseSilla.dart';

class Silla {
  int _numero;
  dynamic _tipoSilla;

  Silla(
    this._numero,
    this._tipoSilla,
  );

  int get numero => _numero;
  ClaseSilla get tipoSilla => _tipoSilla;
  
}
