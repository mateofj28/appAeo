import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//libreria http para realizar consultas a internet
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_fly/model/Aeropuerto.dart';
import 'package:my_fly/model/Avion.dart';
import 'package:my_fly/model/Ciudad.dart';
import 'package:my_fly/model/Pais.dart';
import 'dart:convert';

import 'package:my_fly/model/Vuelo.dart';
import 'package:my_fly/view/ViewItinerario.dart';

import 'model/Itinerario.dart';

class GestionarVuelo extends StatefulWidget {
  @override
  _GestionarVueloState createState() => _GestionarVueloState();
}

class _GestionarVueloState extends State<GestionarVuelo> {
  TextEditingController txtItinerario = new TextEditingController();
  TextEditingController txtAvion = new TextEditingController();
  TextEditingController txtPrecio = new TextEditingController();
  List<ViewItinerario> arrayItinerarios = [];
  List<int> arrayPrecios = [373250, 746500, 1119750, 1493000, 1866250];
  List<String> preciosString = [
    '373,250',
    '746,500',
    '1,119,750',
    '1,493,000',
    '1,866,250'
  ];
  int precios = 0;
  List<Avion> arrayAviones = [];
  var precioValue = 'Seleccionar precio';
  Avion avion;
  Itinerario itinerario;

  Future getAviones() async {
    Avion avion;
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/avion'));
    var data = json.decode(response.body);

    for (var i in data) {
      avion = new Avion(i['id'], i['numero'], i['aerolinias']);

      arrayAviones.add(avion);
    }

    setState(() {});
  }

  Future getItinerarios() async {
    ViewItinerario viewItinerario;
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/itinerario'));
    var data = json.decode(response.body);

    for (var i in data) {
      viewItinerario = new ViewItinerario(
          i['id'],
          i['origen'],
          i['puertoOrigen']['nombre'],
          DateFormat('y-MM-d').format(DateTime.parse(i['fechaSalida'])),
          i['horaSalida'],
          i['destino'],
          i['puertoDestino']['nombre'],
          DateFormat('y-MM-d').format(DateTime.parse(i['fechaLlegada'])),
          i['horaLlegada']);

      arrayItinerarios.add(viewItinerario);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getItinerarios();
    getAviones();
  }

  Future guardarVuelo(Vuelo vuelo) async {
    print(
        'el vuelo se creo ${vuelo.itinerario.fechaSalida}, ${vuelo.precio}, ${vuelo.itinerario.id}, ${vuelo.avion.id}');
    print('es malo?');

    final body = json.encode({
      "itinerario": {
        "id": vuelo.itinerario.id,
        "origen": vuelo.itinerario.origen,
        "puertoOrigen": {
          "id": vuelo.itinerario.puertoOrigen.id,
          "nombre": vuelo.itinerario.puertoOrigen.nombre,
          "ciudad": {
            "id": vuelo.itinerario.puertoOrigen.ciudad.id,
            "nombre": vuelo.itinerario.puertoOrigen.ciudad.nombre,
            "pais": {
              "id": vuelo.itinerario.puertoOrigen.ciudad.pais.id,
              "nombre": vuelo.itinerario.puertoOrigen.ciudad.pais.nombre
            }
          }
        },
        "fechaSalida":
            DateFormat('y-MM-d').format(vuelo.itinerario.fechaSalida),
        "horaSalida": vuelo.itinerario.horaSalida,
        "destino": vuelo.itinerario.destino,
        "puertoDestino": {
          "id": vuelo.itinerario.puertoDestino.id,
          "nombre": vuelo.itinerario.puertoDestino.nombre,
          "ciudad": {
            "id": vuelo.itinerario.puertoDestino.ciudad.id,
            "nombre": vuelo.itinerario.puertoDestino.ciudad.nombre,
            "pais": {
              "id": vuelo.itinerario.puertoDestino.ciudad.pais.id,
              "nombre": vuelo.itinerario.puertoDestino.ciudad.pais.nombre
            }
          }
        },
        "fechaLlegada": DateFormat('y-MM-d').format(vuelo.itinerario.fechaLlegada),
        "horaLlegada": vuelo.itinerario.horaLlegada,
      },
      "avion": {
        "id": vuelo.avion.id,
        "numero": vuelo.avion.numero,
        "aerolinias": vuelo.avion.aerolinias
      },
      "finalizado": null,
      "precio": vuelo.precio
    });

    print('el json paso $body');

    final response = await http.post(
        Uri.parse('http://localhost:8080/api/vuelo'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        });

    print('se mando la data ${response.statusCode}');
    var data = json.decode(response.body);
    print('el vuelo fue: $data bien!!');
  }

  Future getDataItinerario(String id) async {
    final response = await http
        .get(Uri.parse('http://localhost:8080/api/itinerario/id?id=$id'));

    var data = json.decode(response.body);

    var paisSalida = new Pais(data['puertoOrigen']['ciudad']['pais']['id'],
        data['puertoOrigen']['ciudad']['pais']['nombre']);

    var ciudadSalida = new Ciudad(data['puertoOrigen']['ciudad']['id'],
        data['puertoOrigen']['ciudad']['nombre'], paisSalida);

    Aeropuerto puertoSalida = new Aeropuerto(data['puertoOrigen']['id'],
        data['puertoOrigen']['nombre'], ciudadSalida);

    var paisLlegada = new Pais(data['puertoDestino']['ciudad']['pais']['id'],
        data['puertoDestino']['ciudad']['pais']['nombre']);

    var ciudadLlegada = new Ciudad(data['puertoDestino']['ciudad']['id'],
        data['puertoDestino']['ciudad']['nombre'], paisLlegada);

    Aeropuerto puertoLlegada = new Aeropuerto(data['puertoDestino']['id'],
        data['puertoDestino']['nombre'], ciudadLlegada);

    itinerario = new Itinerario.id(
        data['id'],
        data['origen'],
        puertoSalida,
        DateTime.parse(data['fechaSalida']),
        data['horaSalida'],
        data['destino'],
        puertoLlegada,
        DateTime.parse(data['fechaLlegada']),
        data['horaLlegada']);

    print("el itinerario se creo satisfactoriamente");
  }

  Future getDataAviones(String id) async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/avion/id?id=$id'));

    var data = json.decode(response.body);

    avion = new Avion(data['id'], data['numero'], data['aerolinias']);
    print('el avion se guardo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Vuelo'),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100.0, top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      child: Text('Itinerarios'), padding: EdgeInsets.all(14)),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 500.0,
                      height: 255.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3))
                          ]),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: (arrayItinerarios.length >= 1)
                                ? buildTableItinerarios()
                                : CircularProgressIndicator(),
                          )),
                    ),
                  ),
                  Padding(child: Text('Aviones'), padding: EdgeInsets.all(8)),
                  Container(
                      margin: EdgeInsets.only(left: 70.0),
                      width: 320.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3))
                          ]),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: (arrayItinerarios.length >= 1)
                                ? buildTableAviones()
                                : CircularProgressIndicator(),
                          )))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 100.0),
              width: 300.0,
              height: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      child: Text('Itinerarios'), padding: EdgeInsets.all(14)),
                  CupertinoTextField(
                    controller: txtItinerario,
                    placeholder: 'Seleccione en la tabla el id deseado.',
                    readOnly: true,
                    textAlign: TextAlign.center,
                  ),
                  Padding(child: Text('Aviones'), padding: EdgeInsets.all(14)),
                  CupertinoTextField(
                    controller: txtAvion,
                    placeholder: 'Seleccione en la tabla el id deseado.',
                    readOnly: true,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  DropdownButton<String>(
                    hint: Text('$precioValue'),
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blueAccent),
                    underline: Container(
                      height: 2,
                      color: Colors.blue[900],
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        precioValue = newValue;
                        parceValueInt(newValue);
                      });
                    },
                    items: preciosString.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text("$value cop"),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  CupertinoButton(
                      child: Text('Guardar'),
                      color: Colors.blueAccent,
                      onPressed: () {
                        setState(() {
                          Vuelo vuelo =
                              new Vuelo.id(avion, itinerario, null, precios);
                          guardarVuelo(vuelo);
                        });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  DataTable buildTableItinerarios() {
    return DataTable(
        columns: [
          DataColumn(label: Text('id'), tooltip: 'seleccione el id '),
          DataColumn(label: Text('Origen')),
          DataColumn(label: Text('Aeropuerto')),
          DataColumn(label: Text('Fecha salida')),
          DataColumn(label: Text('Hora salida')),
          DataColumn(label: Text('Destino')),
          DataColumn(label: Text('Aeropuerto')),
          DataColumn(label: Text('Fecha salida')),
          DataColumn(label: Text('Hora salida')),
        ],
        rows: arrayItinerarios
            .map((e) => DataRow(cells: [
                  DataCell(Text('${e.id}'), onTap: () {
                    setState(() {
                      txtItinerario.text = e.id.toString();
                      getDataItinerario(txtItinerario.text);
                    });
                  }),
                  DataCell(
                    Text('${e.source}'),
                  ),
                  DataCell(
                    Text('${e.namePort}'),
                  ),
                  DataCell(
                    Text('${e.starDate}'),
                  ),
                  DataCell(
                    Text('${e.startTime}'),
                  ),
                  DataCell(
                    Text('${e.destiny}'),
                  ),
                  DataCell(
                    Text('${e.namePortEnd}'),
                  ),
                  DataCell(
                    Text('${e.endDate}'),
                  ),
                  DataCell(
                    Text('${e.endTime}'),
                  ),
                ]))
            .toList());
  }

  DataTable buildTableAviones() {
    return DataTable(
        columns: [
          DataColumn(label: Text('id')),
          DataColumn(label: Text('Aerolinias')),
          DataColumn(label: Text('Numero avión')),
        ],
        rows: arrayAviones
            .map((e) => DataRow(cells: [
                  DataCell(Text('${e.id}'), onTap: () {
                    setState(() {
                      txtAvion.text = e.id.toString();
                      getDataAviones(txtAvion.text);
                    });
                  }),
                  DataCell(
                    Text('${e.aerolinias}'),
                  ),
                  DataCell(
                    Text('${e.numero}'),
                  )
                ]))
            .toList());
  }

  void parceValueInt(String value) {
    int id = 0;

    for (var i = 0; i < preciosString.length; i++) {
      if (preciosString[i] == value) {
        id = i;
      }
    }

    precios = arrayPrecios[id];
  }
}
/**
 * {
 * "itinerario"
 * 
 * 
 * 
 * 
 * 
 * 
 * }
 * 
 * 
 * 
 */
