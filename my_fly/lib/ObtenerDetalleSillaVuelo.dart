import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_fly/model/Avion.dart';
import 'package:my_fly/model/ClaseSilla.dart';
import 'package:my_fly/model/DetalleSillaVuelo.dart';
import 'package:my_fly/model/Pago.dart';
import 'package:my_fly/model/Pasajero.dart';
import 'package:my_fly/model/Reserva.dart';
import 'package:my_fly/model/Silla.dart';
import 'package:my_fly/model/Vuelo.dart';

import 'model/Aeropuerto.dart';
import 'model/Ciudad.dart';
import 'model/Itinerario.dart';
import 'model/Pais.dart';

// ignore: must_be_immutable
class Botones extends StatefulWidget {
  DetalleSillaVuelo detalle;

  Botones(this.detalle);

  @override
  BotonesState createState() => BotonesState();
}

class BotonesState extends State<Botones> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Text('${widget.detalle.silla.numero}'),
        color: (widget.detalle.reserva != null)
            ? determinarColor(widget.detalle.pago)
            : Colors.blue[100],
        onPressed: () {
          print('${widget.detalle.silla.numero}');
        });
  }

  Color determinarColor(Pago pago) {
    if (pago.valor == null) {
      return Colors.yellow;
    }
    return Colors.red;
  }
}

// ignore: must_be_immutable
class ObtenerDetalleSillaVuelo extends StatefulWidget {
  int avion;
  ObtenerDetalleSillaVuelo(this.avion);

  @override
  ObtenerDetalleSillaVueloState createState() =>
      ObtenerDetalleSillaVueloState();
}

class ObtenerDetalleSillaVueloState extends State<ObtenerDetalleSillaVuelo> {
  Color color = Color(0xff00a8dd);
  List<DetalleSillaVuelo> arrayDetalle = [];

  @override
  void initState() {
    super.initState();
    getDetalleSillaAvion(widget.avion);
  }

  Widget silla(String numero, Color color) {
    return Container(
        width: 5.0,
        height: 50.0,
        margin: EdgeInsets.all(30.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: color),
            onPressed: showAlertDialog,
            child: Text('$numero')));
  }

  Future getDetalleSillaAvion(int avion) async {
    

    final response = await http
        .get(Uri.parse('http://localhost:8080/api/detalle?vuelo=$avion'));

    var dara = json.decode(response.body);

    for (var data in dara) {
      Pais paisOrigen = new Pais(
          data['vuelo']['itinerario']['puertoOrigen']['ciudad']['pais']['id'],
          data['vuelo']['itinerario']['puertoOrigen']['ciudad']['pais']
              ['nombre']);

      Pais paisDestino = new Pais(
          data['vuelo']['itinerario']['puertoDestino']['ciudad']['pais']['id'],
          data['vuelo']['itinerario']['puertoDestino']['ciudad']['pais']
              ['nombre']);

      print('paices bien!');

      Ciudad ciudadOrigen = new Ciudad(
          data['vuelo']['itinerario']['puertoOrigen']['ciudad']['id'],
          data['vuelo']['itinerario']['puertoOrigen']['ciudad']['nombre'],
          paisOrigen);

      Ciudad ciudadDestino = new Ciudad(
          data['vuelo']['itinerario']['puertoDestino']['ciudad']['id'],
          data['vuelo']['itinerario']['puertoDestino']['ciudad']['nombre'],
          paisDestino);

      print('ciudades bien!');

      Aeropuerto puertoOrigen = new Aeropuerto(
          data['vuelo']['itinerario']['puertoOrigen']['id'],
          data['vuelo']['itinerario']['puertoOrigen']['nombre'],
          ciudadOrigen);

      Aeropuerto puertoDestino = new Aeropuerto(
          data['vuelo']['itinerario']['puertoDestino']['id'],
          data['vuelo']['itinerario']['puertoDestino']['nombre'],
          ciudadDestino);

      print('aeropuertos bien!');

      Itinerario itinerario = new Itinerario(
          data['vuelo']['itinerario']['origen'],
          puertoOrigen,
          DateTime.parse(data['vuelo']['itinerario']['fechaSalida']),
          data['vuelo']['itinerario']['horaSalida'],
          data['vuelo']['itinerario']['destino'],
          puertoDestino,
          DateTime.parse(data['vuelo']['itinerario']['fechaLlegada']),
          data['vuelo']['itinerario']['horaLlegada']);

      print('itinerario bien!');

      Avion avion = new Avion(
          data['vuelo']['avion']['id'],
          data['vuelo']['avion']['numero'],
          data['vuelo']['avion']['aerolinias']);

      print('aviones bien!');

      Vuelo vuelo = new Vuelo(data['vuelo']['id'], avion, itinerario,
          data['vuelo']['finalizado'], data['vuelo']['precio']);

      print('vuelos bien!');

      ClaseSilla tipoSilla = new ClaseSilla(
          data['silla']['clase']['id'],
          data['silla']['clase']['precio'],
          data['silla']['clase']['tipoSilla']);

      print('tipoSilla bien!');

      Silla silla = new Silla(data['silla']['numero'], tipoSilla);

      print('el valor fue : ${data['pago']}');
      print('Silla bien!');

      dynamic cliente = null;

      if (data['pago'] != null) {
        cliente = new Pasajero(
            data['pago']['pasajero']['cedula'],
            data['pago']['pasajero']['nombre'],
            data['pago']['pasajero']['apellido'],
            data['pago']['pasajero']['telefono'],
            data['pago']['pasajero']['correo'],
            data['pago']['pasajero']['password']);
      } 

      dynamic pago = null;

      if (data['pago']!= null) {
        pago = new Pago.id(
            data['pago']['id'],
            data['pago']['codigoSegurida'],
            data['pago']['fechaExpedicion'],
            data['pago']['nombreTitular'],
            data['pago']['numeroTarjeta'],
            data['pago']['valor'],
            cliente);
      }

      print('pago bien!');

      dynamic reserva = null;
      if (data['reserva'] != null) {
        reserva = new Reserva.id(data['reserva']['id'], cliente);
      }
      
      print('reserva bien!');

      DetalleSillaVuelo detalle = new DetalleSillaVuelo.id(data['id'],
          data['checking'], data['pasabordo'], pago, reserva, silla, vuelo);

      setState(() {
        arrayDetalle.add(detalle);
      });
    }
    print('todo el detalle bien!!');
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Generar reserva'),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    placeholder: 'Numero de la tarjeta',
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: CupertinoColors.inactiveGray),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      placeholder: 'Nombre y Apellido',
                      style: TextStyle(color: CupertinoColors.inactiveGray)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      placeholder: 'Codigo de segurida',
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: CupertinoColors.inactiveGray)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                      placeholder: 'Numero de cedula',
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: CupertinoColors.inactiveGray)),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Salir')),
              CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).pop();
                      color = Color(0xffffa800);
                    });
                  },
                  child: Text('Reservar')),
            ],
          );
        });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selección silla")),
      body: Center(
        child: Container(
          width: 400.0,
          height: 400.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]),
          child: GridView.count(
            padding: EdgeInsets.all(30),
            primary: false,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              for (int i = 0; i < arrayDetalle.length; i++)
                Botones(arrayDetalle[i])
            ],
          ),
        ),
      ),
    );
  }
}
